DELIMITER $$

CREATE PROCEDURE remove_professional_from_episode(
    IN p_episode_id      INT,
    IN p_professional_id INT
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Episode_Professional
        WHERE episode_id = p_episode_id
        AND professional_id = p_professional_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Relation not found.';
    END IF;

    DELETE
    FROM Episode_Professional
    WHERE episode_id = p_episode_id
    AND professional_id = p_professional_id;

END$$

DELIMITER ;