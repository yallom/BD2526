DELIMITER $$

CREATE PROCEDURE assign_equipment_to_episode(
    IN p_episode_id   INT,
    IN p_equipment_id INT
)
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
        FROM Equipment
        WHERE id = p_equipment_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment not found.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Episode_Equipment
        WHERE episode_id = p_episode_id
        AND equipment_id = p_equipment_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment already assigned to episode.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Equipment
        WHERE id = p_equipment_id
        AND state IN ('maintenance', 'inoperable')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment is unavailable.';
    END IF;

    INSERT INTO Episode_Equipment (
        episode_id,
        equipment_id
    )
    VALUES (
        p_episode_id,
        p_equipment_id
    );

    SELECT *
    FROM Episode_Equipment
    WHERE episode_id = p_episode_id
    AND equipment_id = p_equipment_id;

END$$

DELIMITER ;