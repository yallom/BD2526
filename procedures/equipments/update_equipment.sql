DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE update_equipment(
    IN p_id             INT,
    IN p_serial_number  VARCHAR(100),
    IN p_brand          VARCHAR(100),
    IN p_model          VARCHAR(100),
    IN p_category       VARCHAR(100),
    IN p_state          ENUM('available', 'unavailable', 'maintenance', 'inoperable'),
    IN p_use_time       INT,
    IN p_last_repair    DATETIME,
    IN p_next_repair    DATETIME
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

    UPDATE Equipment
    SET
        serial_number = COALESCE(p_serial_number, serial_number),
        brand         = COALESCE(p_brand, brand),
        model         = COALESCE(p_model, model),
        category      = COALESCE(p_category, category),
        state         = COALESCE(p_state, state),
        use_time      = COALESCE(p_use_time, use_time),
        last_repair   = COALESCE(p_last_repair, last_repair),
        next_repair   = COALESCE(p_next_repair, next_repair)
    WHERE id = p_id;

    SELECT *
    FROM Equipment
    WHERE id = p_id;

END$$

DELIMITER ;