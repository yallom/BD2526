DELIMITER $$
CREATE TRIGGER procedure_equipment_ok
BEFORE INSERT ON Procedure_Equipment
FOR EACH ROW
BEGIN
    DECLARE eq_state ENUM('available','unavailable','maintenance','inoperable');

    SELECT state INTO eq_state
    FROM Equipment
    WHERE id = NEW.equipment_id;

    IF eq_state != 'available' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot assign equipment: it is not available.';
    END IF;
END$$
DELIMITER ;