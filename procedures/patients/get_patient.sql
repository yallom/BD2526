DELIMITER $$
CREATE PROCEDURE get_patient(IN p_id INT)
BEGIN
    IF p_id IS NULL THEN
        SELECT * FROM Patient;
    ELSE
    
		IF NOT EXISTS (SELECT 1 FROM Patient WHERE id = p_id) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Patient not found.';
		END IF;
        
        SELECT * FROM Patient WHERE id = p_id;
        
    END IF;
END$$
DELIMITER ;