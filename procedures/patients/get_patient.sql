DELIMITER $$
CREATE PROCEDURE get_patient(IN p_id INT)
BEGIN
    IF p_id IS NULL THEN
        SELECT * FROM Patient;
    ELSE
        SELECT * FROM Patient WHERE id = p_id;
    END IF;
END$$
DELIMITER ;