DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE create_equipment(
    IN p_serial_number VARCHAR(100),
    IN p_brand         VARCHAR(100),
    IN p_model         VARCHAR(100),
    IN p_category      VARCHAR(100),
    IN p_state         ENUM('available', 'unavailable', 'maintenance', 'inoperable'),
    IN p_use_time      INT,
    IN p_last_repair   DATETIME,
    IN p_next_repair   DATETIME
)
SQL SECURITY DEFINER
BEGIN

    IF p_state IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment state is required.';
    END IF;

    IF p_serial_number IS NOT NULL 
       AND TRIM(p_serial_number) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Serial number cannot be empty.';
    END IF;

    IF p_use_time IS NOT NULL 
       AND p_use_time < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Use time cannot be negative.';
    END IF;

    IF p_last_repair IS NOT NULL 
       AND p_last_repair > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Last repair date cannot be in the future.';
    END IF;

    IF p_next_repair IS NOT NULL 
       AND p_last_repair IS NOT NULL
       AND p_next_repair < p_last_repair THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Next repair date must be after last repair date.';
    END IF;

    INSERT INTO Equipment (
        serial_number,
        brand,
        model,
        category,
        state,
        use_time,
        last_repair,
        next_repair
    )
    VALUES (
        p_serial_number,
        p_brand,
        p_model,
        p_category,
        p_state,
        p_use_time,
        p_last_repair,
        p_next_repair
    );

    SELECT *
    FROM Equipment
    WHERE id = LAST_INSERT_ID();

END$$

DELIMITER ;