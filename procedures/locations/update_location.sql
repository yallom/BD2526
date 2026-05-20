DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE update_location(
    IN p_id      INT,
    IN p_number  INT,
    IN p_floor   INT,
    IN p_state   ENUM('available', 'unavailable', 'maintenance', 'inoperable')
)
SQL SECURITY DEFINER
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Location
        WHERE id = p_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Location not found.';
    END IF;

    IF p_number IS NOT NULL AND p_number < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Location number cannot be negative.';
    END IF;

    IF p_floor IS NOT NULL AND p_floor < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Floor cannot be negative.';
    END IF;

    UPDATE Location
    SET
        number = COALESCE(p_number, number),
        floor  = COALESCE(p_floor, floor),
        state  = COALESCE(p_state, state)
    WHERE id = p_id;

    SELECT *
    FROM Location
    WHERE id = p_id;

END$$

DELIMITER ;