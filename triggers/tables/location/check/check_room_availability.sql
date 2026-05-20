-- FILE: triggers\relational\location_patient_capacity.sql

DELIMITER $$

CREATE TRIGGER check_room_availability
BEFORE INSERT ON Location_Patient
FOR EACH ROW
BEGIN
    DECLARE loc_type     ENUM('room','operating_room','emergency_room','examination_room');
    DECLARE loc_capacity INT;
    DECLARE loc_count    INT;

    SELECT type INTO loc_type
    FROM Location
    WHERE id = NEW.location_id;

    SET loc_capacity = CASE loc_type
        WHEN 'room'             THEN 3
        WHEN 'operating_room'   THEN 1
        WHEN 'emergency_room'   THEN 4
        WHEN 'examination_room' THEN 2
    END;

    SELECT COUNT(*) INTO loc_count
    FROM Location_Patient
    WHERE location_id = NEW.location_id
      AND left_at IS NULL;

    IF loc_count >= loc_capacity THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = CONCAT('Cannot assign patient: location has reached maximum capacity (', loc_capacity, ').');
    END IF;

END$$

DELIMITER ;