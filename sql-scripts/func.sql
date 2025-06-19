CREATE OR REPLACE FUNCTION GetSubgenres(p_RootGenreName VARCHAR(255))
RETURNS TABLE (SubGenreName VARCHAR(255))
LANGUAGE sql STABLE
AS $$
    WITH RECURSIVE GenreHierarchyCTE AS (
        SELECT GenreName
        FROM Genres
        WHERE GenreName = p_RootGenreName

        UNION ALL

        SELECT g.GenreName
        FROM Genres g
        INNER JOIN GenreHierarchyCTE gh ON g.ParentGenre = gh.GenreName
    )
    SELECT GenreName FROM GenreHierarchyCTE;
$$;

CREATE OR REPLACE PROCEDURE AddReleaseWithTracks(
    p_ReleaseTitle VARCHAR(255),
    p_ReleaseDate DATE,
    p_ReleaseType VARCHAR(50),
    p_TrackTitles TEXT[], -- Массив названий треков
    p_TrackDurations TIME[] DEFAULT NULL, -- Массив длительностей, может быть NULL
    p_TrackSpotifyLinks VARCHAR(2048)[] DEFAULT NULL, -- Массив ссылок, может быть null
    p_ReleaseSpotifyLink VARCHAR(2048) DEFAULT NULL,
    p_ReleaseBandcampLink VARCHAR(2048) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_NewReleaseId INTEGER;
    i INTEGER;
    v_NumTracks INTEGER;
BEGIN
    v_NumTracks := array_length(p_TrackTitles, 1);

    IF v_NumTracks IS NULL OR v_NumTracks = 0 THEN
        RAISE EXCEPTION 'At least one track title must be provided in p_TrackTitles.';
    END IF;

    IF p_TrackDurations IS NOT NULL AND array_length(p_TrackDurations, 1) <> v_NumTracks THEN
        RAISE EXCEPTION 'p_TrackTitles and p_TrackDurations arrays must have the same length if p_TrackDurations is provided.';
    END IF;

    IF p_TrackSpotifyLinks IS NOT NULL AND array_length(p_TrackSpotifyLinks, 1) <> v_NumTracks THEN
        RAISE EXCEPTION 'p_TrackTitles and p_TrackSpotifyLinks arrays must have the same length if p_TrackSpotifyLinks is provided.';
    END IF;

    -- Вставляем релиз и получаем его ID
    INSERT INTO Releases (Title, ReleaseDate, Type, SpotifyLink, BandcampLink)
    VALUES (p_ReleaseTitle, p_ReleaseDate, p_ReleaseType, p_ReleaseSpotifyLink, p_ReleaseBandcampLink)
    RETURNING ReleaseId INTO v_NewReleaseId;

    -- Вставляем треки
    FOR i IN 1..v_NumTracks LOOP
        INSERT INTO Tracks (ReleaseId, NumberInRelease, Title, Duration, SpotifyLink)
        VALUES (
            v_NewReleaseId,
            i, -- Номер трека в релизе
            p_TrackTitles[i],
            CASE WHEN p_TrackDurations IS NOT NULL THEN p_TrackDurations[i] ELSE NULL END,
            CASE WHEN p_TrackSpotifyLinks IS NOT NULL THEN p_TrackSpotifyLinks[i] ELSE NULL END
        );
    END LOOP;

END;
$$;

CREATE OR REPLACE FUNCTION GetArtistDiscography(
    p_ArtistId INTEGER
)
RETURNS TABLE (
    ReleaseId INTEGER,
    ReleaseTitle VARCHAR(255),
    ReleaseDate DATE,
    ReleaseType VARCHAR(50),
    AverageRating NUMERIC(3,2), -- Средний рейтинг релиза
    VotesCount INTEGER        -- Количество оценок
)
LANGUAGE sql STABLE
AS $$
    SELECT
        r.ReleaseId,
        r.Title AS ReleaseTitle,
        r.ReleaseDate,
        r.Type AS ReleaseType,
        COALESCE(AVG(rat.RatingOutOf10), 0.0) AS AverageRating,
        COALESCE(COUNT(rat.RatingId), 0) AS VotesCount
    FROM Releases r
    -- Чтобы связать релиз с артистом, нам нужно пройти через треки
    -- Этот JOIN гарантирует, что мы берем релизы, где хотя бы один трек принадлежит артисту
    JOIN Tracks t ON r.ReleaseId = t.ReleaseId
    JOIN TracksArtists ta ON t.TrackId = ta.TrackId
    LEFT JOIN Ratings rat ON r.ReleaseId = rat.ReleaseId -- LEFT JOIN для релизов без оценок
    WHERE ta.ArtistId = p_ArtistId
    GROUP BY r.ReleaseId, r.Title, r.ReleaseDate, r.Type
    ORDER BY r.ReleaseDate DESC, r.Title ASC;
$$;
