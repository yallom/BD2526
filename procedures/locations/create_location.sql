DELIMITER $$

CREATE PROCEDURE create_location(
    IN p_number INT,
    IN p_floor  INT,
    IN p_state  ENUM('available', 'unavailable', 'maintenance', 'inoperable')
)
BEGIN

    IF p_state IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Location state is required.';
    END IF;

    IF p_number IS NOT NULL AND p_number < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Location number cannot be negative.';
    END IF;

    IF p_floor IS NOT NULL AND p_floor < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Floor cannot be negative.';
    END IF;

    INSERT INTO Location (
        number,
        floor,
        state
    )
    VALUES (
        p_number,
        p_floor,
        p_state
    );

    SELECT *
    FROM Location
    WHERE id = LAST_INSERT_ID();

END$$

DELIMITER ;