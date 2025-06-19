DROP INDEX IF EXISTS idx_tracksartists_artistid_hash;
CREATE INDEX idx_tracksartists_artistid_hash
ON TracksArtists USING HASH (ArtistId);

DROP INDEX IF EXISTS idx_tracksgenres_genreid_hash;
CREATE INDEX idx_tracksgenres_genreid_hash
ON TracksGenres USING HASH (GenreName);

DROP INDEX IF EXISTS idx_tracks_trackid_hash;
CREATE INDEX idx_tracks_trackid_hash
ON Tracks USING HASH (TrackId);

DROP INDEX IF EXISTS idx_usersarchive_userid_validto;
CREATE INDEX idx_usersarchive_userid_validto
ON UsersArchive (UserId, ValidTo DESC);

