CREATE OR REPLACE FUNCTION fn_ArchiveUserChanges()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_ArchiveValidFrom DATE;
BEGIN
    -- Проверяем, действительно ли изменились отслеживаемые поля.
    IF OLD.Nickname IS DISTINCT FROM NEW.Nickname OR
       OLD.BirthDate IS DISTINCT FROM NEW.BirthDate OR
       OLD.Gender IS DISTINCT FROM NEW.Gender OR
       OLD.Status IS DISTINCT FROM NEW.Status
    THEN
        -- Определяем ValidFrom для устаревшей записи.
        SELECT COALESCE(MAX(ua.ValidTo) + INTERVAL '1 day', OLD.RegistrationDate)
        INTO v_ArchiveValidFrom
        FROM UsersArchive ua
        WHERE ua.UserId = OLD.UserId AND ua.ValidTo < OLD.RegistrationDate; -- Ищем последнюю запись

        INSERT INTO UsersArchive (
            UserId,
            ValidFrom,
            ValidTo,
            Nickname,
            BirthDate,
            Gender,
            Status
        ) VALUES (
            OLD.UserId,
            v_ArchiveValidFrom,
            CURRENT_DATE - INTERVAL '1 day',
            OLD.Nickname,
            OLD.BirthDate,
            OLD.Gender,
            OLD.Status
        );
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ArchiveUserChanges
BEFORE UPDATE ON Users
FOR EACH ROW
WHEN (OLD.* IS DISTINCT FROM NEW.*)
EXECUTE FUNCTION fn_ArchiveUserChanges();


CREATE OR REPLACE FUNCTION fn_CheckTrackNumber()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка на положительность номера
    IF NEW.NumberInRelease <= 0 THEN
        RAISE EXCEPTION 'Track number (NumberInRelease) must be positive. Value provided: %', NEW.NumberInRelease;
    END IF;

    -- Проверка на уникальность номера трека в рамках релиза
    IF EXISTS (
        SELECT 1
        FROM Tracks
        WHERE ReleaseId = NEW.ReleaseId
          AND NumberInRelease = NEW.NumberInRelease
          AND TrackId IS DISTINCT FROM NEW.TrackId
    ) THEN
        RAISE EXCEPTION 'Track number % already exists for release ID %.', NEW.NumberInRelease, NEW.ReleaseId;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_CheckTrackNumber
BEFORE INSERT OR UPDATE ON Tracks
FOR EACH ROW
EXECUTE FUNCTION fn_CheckTrackNumber();


CREATE OR REPLACE FUNCTION fn_SetUserRegistrationDate()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Если RegistrationDate не указана при вставке, устанавливаем текущую дату
    IF NEW.RegistrationDate IS NULL THEN
        NEW.RegistrationDate := CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_SetUserRegistrationDate
BEFORE INSERT ON Users
FOR EACH ROW
EXECUTE FUNCTION fn_SetUserRegistrationDate();