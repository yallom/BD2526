DELIMITER $$

CREATE PROCEDURE delete_location(
    IN p_id   INT,
    IN p_hard BOOLEAN
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Location
        WHERE id = p_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Location not found.';
    END IF;

    IF p_hard THEN

        DELETE
        FROM Location
        WHERE id = p_id;

    ELSE

        UPDATE Location
        SET deleted_at = CURDATE()
        WHERE id = p_id;

        SELECT *
        FROM Location
        WHERE id = p_id;

    END IF;

END$$

DELIMITER ;