DELIMITER $$
CREATE DEFINER='app_admin'@'localhost' PROCEDURE delete_patient(
    IN p_id   INT,
    IN p_hard BOOLEAN   -- FALSE = soft delete, TRUE = hard delete
)
SQL SECURITY DEFINER
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Patient WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Patient not found.';
    END IF;

    IF p_hard THEN
        DELETE FROM Patient WHERE id = p_id;
    ELSE
        UPDATE Patient SET deleted_at = CURDATE() WHERE id = p_id;
        SELECT * FROM Patient WHERE id = p_id;
    END IF;
END$$
DELIMITER ;