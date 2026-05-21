DELIMITER $$
 
CREATE TRIGGER vacate_on_soft_delete
BEFORE UPDATE ON Location
FOR EACH ROW
BEGIN
 
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
        CALL vacate_location(OLD.id);
    END IF;
 
END$$
 
DELIMITER ;
