DELIMITER $$

CREATE TRIGGER vacate_on_hard_delete
BEFORE DELETE ON Location
FOR EACH ROW
BEGIN
    CALL vacate_location(OLD.id);
END$$

DELIMITER ;