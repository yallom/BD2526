DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE assign_professional_to_episode(
    IN p_episode_id      INT,
    IN p_professional_id INT
)
SQL SECURITY DEFINER
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Episode
        WHERE id = p_episode_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Episode not found.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Professional
        WHERE id = p_professional_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Professional not found.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Episode_Professional
        WHERE episode_id = p_episode_id
        AND professional_id = p_professional_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Professional already assigned to episode.';
    END IF;

    INSERT INTO Episode_Professional (
        episode_id,
        professional_id
    )
    VALUES (
        p_episode_id,
        p_professional_id
    );

    SELECT *
    FROM Episode_Professional
    WHERE episode_id = p_episode_id
    AND professional_id = p_professional_id;

END$$

DELIMITER ;