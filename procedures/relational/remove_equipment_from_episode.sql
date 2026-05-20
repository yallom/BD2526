DELIMITER $$

CREATE PROCEDURE remove_equipment_from_episode(
    IN p_episode_id   INT,
    IN p_equipment_id INT
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Episode_Equipment
        WHERE episode_id = p_episode_id
        AND equipment_id = p_equipment_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Relation not found.';
    END IF;

    DELETE
    FROM Episode_Equipment
    WHERE episode_id = p_episode_id
    AND equipment_id = p_equipment_id;

END$$

DELIMITER ;