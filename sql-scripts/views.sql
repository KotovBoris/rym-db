CREATE or replace VIEW TopCurrentReleases as
-- Расчитываем распределение женров для каждого релиза
WITH ReleaseGenreCounts AS (
    SELECT
        t.ReleaseId,
        tg.GenreName,
        COUNT(*) AS GenreOccurrences,
        ROW_NUMBER() OVER (PARTITION BY t.ReleaseId ORDER BY COUNT(*) DESC) as rn
    FROM Tracks t
    JOIN TracksGenres tg ON t.TrackId = tg.TrackId
    GROUP BY t.ReleaseId, tg.GenreName
),

-- Оставляем только самый частый жанр для каждлого релиза
DominantReleaseGenre AS (
    SELECT
        ReleaseId,
        GenreName AS DominantGenre
    FROM ReleaseGenreCounts
    WHERE rn = 1
),

-- Расчитываем среднуюю оценку и кол-во оценок для каждого релиза
ReleaseRatingStats AS (
    SELECT
        ReleaseId,
        AVG(RatingOutOf10) AS AverageRating,
        COUNT(RatingId) AS VotesCount
    FROM Ratings
    GROUP BY ReleaseId
)
SELECT
    r.ReleaseId,
    r.Title AS ReleaseTitle,
    r.ReleaseDate,
    r.Type AS ReleaseType,
    COALESCE(rrs.AverageRating, 0.0) AS AverageRating, -- Нет оценок => средний рейтинг = 0
    COALESCE(rrs.VotesCount, 0) AS VotesCount,         -- Нет оценок => количество голосов = 0
    drg.DominantGenre
FROM Releases r
LEFT JOIN ReleaseRatingStats rrs ON r.ReleaseId = rrs.ReleaseId
LEFT JOIN DominantReleaseGenre drg ON r.ReleaseId = drg.ReleaseId
-- WHERE r.ReleaseDate >= (CURRENT_DATE - INTERVAL '1 years') -- Релизы за последний год
ORDER BY AverageRating DESC, VotesCount DESC;

CREATE or replace VIEW TopActiveUsers as
-- Считаем количество рецензий (Review >= 20 символов) и средний рейтинг для каждого пользователя
WITH UserActivity AS (
    SELECT
        UserId,
        COUNT(CASE WHEN LENGTH(Review) >= 20 THEN 1 ELSE NULL END) AS ReviewCount,
        AVG(RatingOutOf10) AS AverageUserRatingAll
    FROM Ratings
    GROUP BY UserId
)
SELECT
    u.UserId,
    u.Nickname AS UserNickname,
    COALESCE(ua.ReviewCount, 0) AS ReviewCount,
    ua.AverageUserRatingAll
FROM Users u
LEFT JOIN UserActivity ua ON u.UserId = ua.UserId
ORDER BY ReviewCount DESC, AverageUserRatingAll DESC;