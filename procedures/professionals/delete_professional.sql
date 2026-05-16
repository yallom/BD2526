DELIMITER $$

CREATE PROCEDURE delete_professional(
    IN p_id   INT,
    IN p_hard BOOLEAN   -- FALSE = soft delete, TRUE = hard delete
)
BEGIN

    IF NOT EXISTS (
        SELECT 1 
        FROM Professional 
        WHERE id = p_id
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Professional not found.';
    END IF;

    IF p_hard THEN

        DELETE 
        FROM Professional 
        WHERE id = p_id;

    ELSE

        UPDATE Professional
        SET deleted_at = CURDATE()
        WHERE id = p_id;

        SELECT * 
        FROM Professional 
        WHERE id = p_id;

    END IF;

END$$

DELIMITER ;