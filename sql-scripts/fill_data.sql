-- =========================
-- Заполнение таблицы Genres (15 строк)
-- =========================
INSERT INTO Genres (GenreName, ParentGenre, Description) VALUES
('Rock', NULL, 'Rock music genre'),
('Alternative Rock', 'Rock', 'Alternative style of rock'),
('Pop', NULL, 'Popular music genre'),
('Hip-Hop', NULL, 'Hip-hop music with rap vocals'),
('Jazz', NULL, 'Jazz music genre'),
('Electronic', NULL, 'Electronic and dance music'),
('Classical', NULL, 'Traditional classical music'),
('Metal', 'Rock', 'Heavy metal music'),
('Folk', NULL, 'Traditional folk music'),
('Country', NULL, 'Country music style'),
('Blues', NULL, 'Blues genre music'),
('Reggae', NULL, 'Reggae music from Jamaica'),
('Soul', 'R&B', 'Soul music genre'),
('R&B', NULL, 'Rhythm and Blues music'),
('Punk', 'Rock', 'Punk rock, rebellious style');

-- =========================
-- Заполнение таблицы Artists (15 строк)
-- =========================
INSERT INTO Artists (Name, Members, FoundedYear, DisbandedYear) VALUES
('The Rockers', 'John, Paul, George, Ringo', 1960, NULL),
('Electric Pulse', 'Alice, Bob', 1990, NULL),
('Jazz Beats', 'Charlie, Dave', 1985, NULL),
('Hip-Hop Crew', 'Eve, Frank, Grace', 2000, NULL),
('Pop Stars', 'Hannah, Irene, Jack', 2010, NULL),
('Metal Heads', 'Kevin, Liam', 1975, 1995),
('Folk Tales', 'Mona, Nora', 1980, NULL),
('Country Roads', 'Oscar, Pam', 1970, NULL),
('Blues Brothers', 'Quincy, Rick', 1955, NULL),
('Reggae Vibes', 'Sam, Tom', 1988, NULL),
('Soul Sensations', 'Uma, Vic', 1995, NULL),
('Rhythm Masters', 'Wendy, Xavier', 2005, NULL),
('Punk Rebels', 'Yara, Zack', 1978, NULL),
('Alternative Notes', 'Adam, Bella', 2003, NULL),
('Classical Ensemble', 'Cecilia, Dominic', 1950, 2000);

-- =========================
-- Заполнение таблицы Releases (15 строк)
-- =========================
INSERT INTO Releases (Title, ReleaseDate, Type, SpotifyLink, BandcampLink) VALUES
('Rocking Start', '1961-03-01', 'Album', 'http://spotify.com/rockingstart', 'http://bandcamp.com/rockingstart'),
('Electric Dreams', '1991-06-15', 'Album', 'http://spotify.com/electricdreams', 'http://bandcamp.com/electricdreams'),
('Smooth Jazz', '1986-09-20', 'Album', 'http://spotify.com/smoothjazz', 'http://bandcamp.com/smoothjazz'),
('Rap Revolution', '2001-11-05', 'Album', 'http://spotify.com/raprevolution', 'http://bandcamp.com/raprevolution'),
('Pop Explosion', '2011-07-22', 'Album', 'http://spotify.com/popexplosion', 'http://bandcamp.com/popexplosion'),
('Heavy Metal Thunder', '1976-04-10', 'Album', 'http://spotify.com/heavymetal', 'http://bandcamp.com/heavymetal'),
('Folk Stories', '1981-02-14', 'Album', 'http://spotify.com/folkstories', 'http://bandcamp.com/folkstories'),
('Country Classics', '1971-08-30', 'Album', 'http://spotify.com/countryclassics', 'http://bandcamp.com/countryclassics'),
('Blue Notes', '1956-12-12', 'Album', 'http://spotify.com/bluenotes', 'http://bandcamp.com/bluenotes'),
('Island Reggae', '1989-03-28', 'Album', 'http://spotify.com/islandreggae', 'http://bandcamp.com/islandreggae'),
('Soulful Evening', '1996-05-05', 'Album', 'http://spotify.com/soulfulevening', 'http://bandcamp.com/soulfulevening'),
('Rhythm and Blues', '2006-10-10', 'Album', 'http://spotify.com/rhythmblues', 'http://bandcamp.com/rhythmblues'),
('Punk Uprising', '1979-01-01', 'Album', 'http://spotify.com/punkuprising', 'http://bandcamp.com/punkuprising'),
('Alternative Waves', '2004-04-04', 'Album', 'http://spotify.com/alternativewaves', 'http://bandcamp.com/alternativewaves'),
('Classical Moods', '1951-09-09', 'Album', 'http://spotify.com/classicalmoods', 'http://bandcamp.com/classicalmoods');

-- =========================
-- Заполнение таблицы Tracks (30 строк)
-- =========================
INSERT INTO Tracks (ReleaseId, NumberInRelease, Title, Duration, SpotifyLink) VALUES
(1, 1, 'Rock Intro', '00:02:30', 'http://spotify.com/track1'),
(1, 2, 'Rock Anthem', '00:04:00', 'http://spotify.com/track2'),
(2, 1, 'Electric Beat', '00:03:45', 'http://spotify.com/track3'),
(2, 2, 'Dream Sequence', '00:05:10', 'http://spotify.com/track4'),
(3, 1, 'Smooth Start', '00:04:20', 'http://spotify.com/track5'),
(3, 2, 'Jazz Groove', '00:06:00', 'http://spotify.com/track6'),
(4, 1, 'Rap Verse', '00:03:00', 'http://spotify.com/track7'),
(4, 2, 'Hip-Hop Beat', '00:04:15', 'http://spotify.com/track8'),
(5, 1, 'Pop Intro', '00:02:50', 'http://spotify.com/track9'),
(5, 2, 'Pop Hit', '00:03:40', 'http://spotify.com/track10'),
(6, 1, 'Metal Riff', '00:03:30', 'http://spotify.com/track11'),
(6, 2, 'Thunder Strike', '00:04:50', 'http://spotify.com/track12'),
(7, 1, 'Folk Melody', '00:03:20', 'http://spotify.com/track13'),
(7, 2, 'Story Song', '00:05:00', 'http://spotify.com/track14'),
(8, 1, 'Country Roads', '00:04:00', 'http://spotify.com/track15'),
(9, 1, 'Blue Mood', '00:03:55', 'http://spotify.com/track16'),
(10, 1, 'Reggae Rhythm', '00:04:10', 'http://spotify.com/track17'),
(10, 2, 'Island Beat', '00:03:50', 'http://spotify.com/track18'),
(10, 3, 'Tropical Vibe', '00:04:20', 'http://spotify.com/track19'),
(10, 4, 'Sunset Jam', '00:05:05', 'http://spotify.com/track20'),
(11, 1, 'Soul Intro', '00:03:10', 'http://spotify.com/track21'),
(11, 2, 'Evening Groove', '00:04:45', 'http://spotify.com/track22'),
(12, 1, 'Rhythm Pulse', '00:03:35', 'http://spotify.com/track23'),
(12, 2, 'Bluesy Tune', '00:05:15', 'http://spotify.com/track24'),
(13, 1, 'Punk Start', '00:02:55', 'http://spotify.com/track25'),
(13, 2, 'Rebel Yell', '00:03:40', 'http://spotify.com/track26'),
(14, 1, 'Alternative Beat', '00:03:20', 'http://spotify.com/track27'),
(14, 2, 'Waves', '00:04:30', 'http://spotify.com/track28'),
(15, 1, 'Classical Overture', '00:05:00', 'http://spotify.com/track29'),
(15, 2, 'Symphony', '00:07:00', 'http://spotify.com/track30');

-- =========================
-- Заполнение таблицы Users и UsersArchive (15 пользователей, у каждого 2 версии)
-- =========================

-- Вставляем данные в Users (используем актуальную версию из UsersInfo):
INSERT INTO Users (UserId, RegistrationDate, Nickname, BirthDate, Gender, Status) VALUES
(1, '2020-01-10', 'User1_v2', '1990-05-05', 'Male', 'Active'),
(2, '2020-02-15', 'User2_v2', '1988-03-15', 'Female', 'Active'),
(3, '2020-03-20', 'User3_v2', '1992-07-07', 'Male', 'Active'),
(4, '2020-04-25', 'User4_v2', '1995-01-01', 'Female', 'Active'),
(5, '2020-05-30', 'User5_v2', '1985-12-12', 'Male', 'Active'),
(6, '2020-06-05', 'User6_v2', '1991-04-20', 'Female', 'Active'),
(7, '2020-07-10', 'User7_v2', '1993-06-15', 'Male', 'Active'),
(8, '2020-08-15', 'User8_v2', '1989-09-09', 'Female', 'Active'),
(9, '2020-09-20', 'User9_v2', '1990-11-11', 'Male', 'Active'),
(10, '2020-10-25', 'User10_v2', '1994-02-02', 'Female', 'Active'),
(11, '2020-11-30', 'User11_v2', '1987-07-07', 'Male', 'Active'),
(12, '2020-12-05', 'User12_v2', '1992-10-10', 'Female', 'Active'),
(13, '2021-01-10', 'User13_v2', '1990-08-08', 'Male', 'Active'),
(14, '2021-02-15', 'User14_v2', '1986-06-06', 'Female', 'Active'),
(15, '2021-03-20', 'User15_v2', '1993-03-03', 'Male', 'Active');

-- Вставляем исторические данные в UsersArchive (предыдущая версия для каждого пользователя):
INSERT INTO UsersArchive (UserId, ValidFrom, ValidTo, Nickname, BirthDate, Gender, Status) VALUES
(1, '2020-01-10', '2020-06-30', 'User1_v1', '1990-05-05', 'Male', 'Active'),
(2, '2020-02-15', '2020-07-31', 'User2_v1', '1988-03-15', 'Female', 'Active'),
(3, '2020-03-20', '2020-08-31', 'User3_v1', '1992-07-07', 'Male', 'Inactive'),
(4, '2020-04-25', '2020-09-30', 'User4_v1', '1995-01-01', 'Female', 'Active'),
(5, '2020-05-30', '2020-10-31', 'User5_v1', '1985-12-12', 'Male', 'Active'),
(6, '2020-06-05', '2020-11-30', 'User6_v1', '1991-04-20', 'Female', 'Active'),
(7, '2020-07-10', '2020-12-31', 'User7_v1', '1993-06-15', 'Male', 'Active'),
(8, '2020-08-15', '2021-01-31', 'User8_v1', '1989-09-09', 'Female', 'Inactive'),
(9, '2020-09-20', '2021-02-28', 'User9_v1', '1990-11-11', 'Male', 'Active'),
(10, '2020-10-25', '2021-03-31', 'User10_v1', '1994-02-02', 'Female', 'Active'),
(11, '2020-11-30', '2021-04-30', 'User11_v1', '1987-07-07', 'Male', 'Active'),
(12, '2020-12-05', '2021-05-31', 'User12_v1', '1992-10-10', 'Female', 'Inactive'),
(13, '2021-01-10', '2021-06-30', 'User13_v1', '1990-08-08', 'Male', 'Active'),
(14, '2021-02-15', '2021-07-31', 'User14_v1', '1986-06-06', 'Female', 'Active'),
(15, '2021-03-20', '2021-08-31', 'User15_v1', '1993-03-03', 'Male', 'Inactive');

-- =========================
-- Заполнение таблицы Ratings (15 строк)
-- =========================
INSERT INTO Ratings (ReleaseId, UserId, RatingOutOf10, Review) VALUES
(1, 1, 8, 'Great start!'),
(2, 2, 7, 'Energetic beats.'),
(3, 3, 9, 'Smooth and relaxing.'),
(4, 4, 6, 'Good rap flow.'),
(5, 5, 8, 'Pop perfection.'),
(6, 6, 5, 'Too heavy for me.'),
(7, 7, 7, 'Lovely folk tunes.'),
(8, 8, 8, 'Classic country vibes.'),
(9, 9, 9, 'Blues at its best.'),
(10, 10, 8, 'Reggae rhythms are infectious.'),
(11, 11, 7, 'Soulful melodies.'),
(12, 12, 8, 'Rhythmic and smooth.'),
(13, 13, 6, 'Energetic punk sound.'),
(14, 14, 7, 'Unique alternative style.'),
(15, 15, 9, 'Beautiful classical pieces.');

-- =========================
-- Заполнение таблицы TracksGenres (31 строк)
-- =========================
INSERT INTO TracksGenres (GenreName, TrackId) VALUES
('Rock', 1),
('Alternative Rock', 1),
('Rock', 2),
('Electronic', 3),
('Electronic', 4),
('Jazz', 5),
('Jazz', 6),
('Hip-Hop', 7),
('Hip-Hop', 8),
('Pop', 9),
('Pop', 10),
('Metal', 11),
('Metal', 12),
('Folk', 13),
('Folk', 14),
('Country', 15),
('Blues', 16),
('Reggae', 17),
('Reggae', 18),
('Reggae', 19),
('Reggae', 20),
('Soul', 21),
('Soul', 22),
('R&B', 23),
('R&B', 24),
('Punk', 25),
('Punk', 26),
('Alternative Rock', 27),
('Alternative Rock', 28),
('Classical', 29),
('Classical', 30);

-- =========================
-- Заполнение таблицы TracksArtists (30 строк)
-- =========================
INSERT INTO TracksArtists (ArtistId, TrackId) VALUES
(1, 1),
(2, 1),
(1, 2),
(2, 3),
(3, 4),
(3, 5),
(4, 6),
(4, 7),
(5, 8),
(5, 9),
(6, 10),
(6, 11),
(7, 12),
(7, 13),
(8, 14),
(8, 15),
(9, 16),
(10, 17),
(10, 18),
(11, 19),
(11, 20),
(12, 21),
(12, 22),
(13, 23),
(13, 24),
(14, 25),
(14, 26),
(15, 27),
(15, 28),
(1, 29),
(2, 30);
