---------------------------------------------------------------
-- 1) Последние 3 зарегистрированных пользователя (по RegistrationDate)
---------------------------------------------------------------
SELECT UserId, Nickname, RegistrationDate
FROM Users
ORDER BY RegistrationDate DESC
LIMIT 3;

---------------------------------------------------------------
-- 2) Количество оценок и средняя оценка для альбома с названием 'Rocking Start'
---------------------------------------------------------------
SELECT r.Title AS AlbumName,
       COUNT(rt.RatingId) AS RatingCount,
       AVG(rt.RatingOutOf10) AS AverageRating
FROM Releases r
LEFT JOIN Ratings rt ON r.ReleaseId = rt.ReleaseId
WHERE r.Title = 'Rocking Start'
GROUP BY r.ReleaseId, r.Title;

---------------------------------------------------------------
-- 3) Топ-альбом в жанре Jazz
---------------------------------------------------------------
WITH jazz_albums AS (
    SELECT r.ReleaseId, r.Title, AVG(rt.RatingOutOf10) AS AvgRating
    FROM Releases r
    INNER JOIN Ratings rt ON r.ReleaseId = rt.ReleaseId
    INNER JOIN Tracks t ON t.ReleaseId = r.ReleaseId
    INNER JOIN TracksGenres tg ON tg.TrackId = t.TrackId
    WHERE tg.GenreName = 'Jazz'
    GROUP BY r.ReleaseId, r.Title
)
SELECT Title, AvgRating
FROM jazz_albums
ORDER BY AvgRating DESC
LIMIT 1;

---------------------------------------------------------------
-- 4) Сколько песен написал каждый исполнитель
---------------------------------------------------------------
SELECT a.Name, COUNT(ta.TrackId) AS SongCount
FROM Artists a
LEFT JOIN TracksArtists ta ON a.ArtistId = ta.ArtistId
GROUP BY a.ArtistId, a.Name
ORDER BY SongCount DESC;

---------------------------------------------------------------
-- 5) Количество рецензий на каждый релиз
---------------------------------------------------------------
SELECT r.Title, COUNT(rt.RatingId) AS ReviewCount
FROM Releases r
LEFT JOIN Ratings rt ON r.ReleaseId = rt.ReleaseId
GROUP BY r.ReleaseId, r.Title
ORDER BY ReviewCount DESC;

---------------------------------------------------------------
-- 6) Средняя оценка каждого пользователя с ранжированием
---------------------------------------------------------------
SELECT u.UserId,
       AVG(r.RatingOutOf10) AS AvgRating,
       RANK() OVER (ORDER BY AVG(r.RatingOutOf10) DESC) AS RatingRank
FROM Users u
LEFT JOIN Ratings r ON u.UserId = r.UserId
GROUP BY u.UserId
ORDER BY RatingRank;

---------------------------------------------------------------
-- 7) Любимый жанр каждого пользователя
---------------------------------------------------------------
SELECT u.Nickname,
       sub.GenreName AS FavoriteGenre
FROM (
    SELECT r.UserId, tg.GenreName, COUNT(*) AS GenreCount,
           ROW_NUMBER() OVER (PARTITION BY r.UserId ORDER BY COUNT(*) DESC) AS rn
    FROM Ratings r
    INNER JOIN Releases rel ON r.ReleaseId = rel.ReleaseId
    INNER JOIN Tracks t ON t.ReleaseId = rel.ReleaseId
    INNER JOIN TracksGenres tg ON t.TrackId = tg.TrackId
    GROUP BY r.UserId, tg.GenreName
) sub
INNER JOIN Users u ON sub.UserId = u.UserId
WHERE sub.rn = 1
ORDER BY u.Nickname;

---------------------------------------------------------------
-- 8) Список релизов, выпущенных за последние 20 лет, с количеством треков в каждом
---------------------------------------------------------------
SELECT r.ReleaseId, r.Title, r.ReleaseDate, COUNT(t.TrackId) AS TrackCount
FROM Releases r
LEFT JOIN Tracks t ON r.ReleaseId = t.ReleaseId
WHERE r.ReleaseDate >= CURRENT_DATE - INTERVAL '20 years'
GROUP BY r.ReleaseId, r.Title, r.ReleaseDate
ORDER BY r.ReleaseDate DESC;

---------------------------------------------------------------
-- 9) Список артистов с более чем 1 альбомом, где средняя оценка треков выше 7
---------------------------------------------------------------
SELECT a.ArtistId, a.Name, COUNT(DISTINCT r.ReleaseId) AS AlbumCount,
       AVG(rat.RatingOutOf10) AS AvgSongRating
FROM Artists a
INNER JOIN TracksArtists ta ON a.ArtistId = ta.ArtistId
INNER JOIN Tracks t ON ta.TrackId = t.TrackId
INNER JOIN Releases r ON t.ReleaseId = r.ReleaseId
INNER JOIN Ratings rat ON r.ReleaseId = rat.ReleaseId
GROUP BY a.ArtistId, a.Name
HAVING COUNT(DISTINCT r.ReleaseId) > 1 AND AVG(rat.RatingOutOf10) > 7
ORDER BY AlbumCount DESC;

---------------------------------------------------------------
-- 10) Для каждого жанра показать последний (по дате выпуска) трек
---------------------------------------------------------------
SELECT GenreName, TrackId, Title, ReleaseDate AS "last released track date"
FROM (
    SELECT 
        g.GenreName, 
        t.TrackId, 
        t.Title, 
        r.ReleaseDate,
        ROW_NUMBER() OVER (PARTITION BY g.GenreName ORDER BY r.ReleaseDate DESC) AS rn
    FROM Genres g
    INNER JOIN TracksGenres tg ON g.GenreName = tg.GenreName
    INNER JOIN Tracks t ON t.TrackId = tg.TrackId
    INNER JOIN Releases r ON r.ReleaseId = t.ReleaseId
) sub
WHERE rn = 1
ORDER BY GenreName;

---------------------------------------------------------------
-- 11) Релизы, у которых есть оценка <= 6
---------------------------------------------------------------
SELECT r.Title
FROM Releases r
WHERE EXISTS (
    SELECT 1
    FROM Ratings rt
    WHERE rt.ReleaseId = r.ReleaseId AND rt.RatingOutOf10 <= 6
);
