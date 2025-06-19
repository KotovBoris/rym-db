SELECT * FROM GetSubgenres('Rock');
SELECT * FROM GetSubgenres('R&B');
SELECT * FROM GetSubgenres('Electronic');

select * from releases r join tracks t on r.releaseid = t.releaseid where r.title = 'Test Release';

CALL AddReleaseWithTracks(
    p_ReleaseTitle := 'Test Release',
    p_ReleaseDate := '1 Jan 2025',
    p_ReleaseType := 'Album',
    p_TrackTitles := ARRAY['Intro', 'Main Theme', 'Outro']
);

select * from releases r join tracks t on r.releaseid = t.releaseid where r.title = 'Test Release';


SELECT * FROM fn_GetArtistDiscography(1);