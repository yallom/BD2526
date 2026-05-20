DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE delete_equipment(
    IN p_id   INT,
    IN p_hard BOOLEAN
)
SQL SECURITY DEFINER
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Equipment
        WHERE id = p_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment not found.';
    END IF;

    IF p_hard THEN

        DELETE
        FROM Equipment
        WHERE id = p_id;

    ELSE

        UPDATE Equipment
        SET deleted_at = CURDATE()
        WHERE id = p_id;

        SELECT *
        FROM Equipment
        WHERE id = p_id;

    END IF;

END$$

DELIMITER ;