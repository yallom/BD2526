DELIMITER $$
CREATE TRIGGER procedure_location_available
BEFORE INSERT ON MedicalProcedure
FOR EACH ROW
BEGIN
    DECLARE loc_state ENUM('available','unavailable','maintenance','inoperable');

    IF NEW.location_id IS NOT NULL THEN
        SELECT state INTO loc_state
        FROM Location
        WHERE id = NEW.location_id;

        IF loc_state != 'available' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Cannot schedule procedure: location is not available.';
        END IF;
    END IF;
END$$
DELIMITER ;