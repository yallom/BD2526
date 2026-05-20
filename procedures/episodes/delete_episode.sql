DELIMITER $$

CREATE PROCEDURE delete_episode(
    IN p_id   INT,
    IN p_hard BOOLEAN
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Episode
        WHERE id = p_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Episode not found.';
    END IF;

    IF p_hard THEN

        DELETE
        FROM Episode
        WHERE id = p_id;

    ELSE

        UPDATE Episode
        SET deleted_at = CURDATE()
        WHERE id = p_id;

        SELECT *
        FROM Episode
        WHERE id = p_id;

    END IF;

END$$

DELIMITER ;