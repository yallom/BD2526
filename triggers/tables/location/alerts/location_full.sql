DELIMITER $$

CREATE TRIGGER location_full
AFTER INSERT ON Location_Patient
FOR EACH ROW
BEGIN
    DECLARE loc_type     ENUM('room','operating_room','emergency_room','examination_room');
    DECLARE loc_capacity INT;
    DECLARE loc_count    INT;
    DECLARE v_msg        VARCHAR(255);

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
        SET v_msg = CONCAT('Location ', NEW.location_id, ' has reached max capacity!');
        INSERT INTO Alert(entity_type, entity_id, reason, message)
        VALUES ('location', NEW.location_id, 'full', v_msg);
    END IF;

END$$

DELIMITER ;