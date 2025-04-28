-- Создание таблицы Genres
CREATE TABLE Genres (
    GenreName VARCHAR(255) PRIMARY KEY,
    ParentGenre VARCHAR(255) REFERENCES Genres(GenreName),
    Description TEXT
);

-- Создание таблицы Artists
CREATE TABLE Artists (
    ArtistId SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Members TEXT,
    FoundedYear INTEGER,
    DisbandedYear INTEGER
);

-- Создание таблицы Releases
CREATE TABLE Releases (
    ReleaseId SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ReleaseDate DATE,
    Type VARCHAR(50) NOT NULL,
    SpotifyLink VARCHAR(2048),
    BandcampLink VARCHAR(2048)
);

-- Создание таблицы Tracks
CREATE TABLE Tracks (
    TrackId SERIAL PRIMARY KEY,
    ReleaseId INTEGER NOT NULL REFERENCES Releases(ReleaseId),
    NumberInRelease INTEGER NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Duration TIME,
    SpotifyLink VARCHAR(2048)
);

-- Создание таблицы Users с актуальной информацией
CREATE TABLE Users (
    UserId SERIAL PRIMARY KEY,
    RegistrationDate DATE NOT NULL,
    Nickname VARCHAR(255) NOT NULL,
    BirthDate DATE,
    Gender VARCHAR(50),
    Status VARCHAR(50)
);

-- Создание таблицы UsersArchive для исторических данных пользователей
CREATE TABLE UsersArchive (
    ArchiveId SERIAL PRIMARY KEY,
    UserId INTEGER NOT NULL REFERENCES Users(UserId),
    ValidFrom DATE NOT NULL,
    ValidTo DATE NOT NULL,
    Nickname VARCHAR(255) NOT NULL,
    BirthDate DATE,
    Gender VARCHAR(50),
    Status VARCHAR(50)
);

-- Создание таблицы Ratings
CREATE TABLE Ratings (
    RatingId SERIAL PRIMARY KEY,
    ReleaseId INTEGER NOT NULL REFERENCES Releases(ReleaseId),
    UserId INTEGER NOT NULL REFERENCES Users(UserId),
    RatingOutOf10 INTEGER NOT NULL CHECK (RatingOutOf10 BETWEEN 1 AND 10),
    Review TEXT
);

-- Создание таблицы TracksGenres (связующая таблица)
CREATE TABLE TracksGenres (
    GenreName VARCHAR(255) NOT NULL REFERENCES Genres(GenreName),
    TrackId INTEGER NOT NULL REFERENCES Tracks(TrackId),
    PRIMARY KEY (GenreName, TrackId)
);

-- Создание таблицы TracksArtists (связующая таблица)
CREATE TABLE TracksArtists (
    ArtistId INTEGER NOT NULL REFERENCES Artists(ArtistId),
    TrackId INTEGER NOT NULL REFERENCES Tracks(TrackId),
    PRIMARY KEY (ArtistId, TrackId)
);
