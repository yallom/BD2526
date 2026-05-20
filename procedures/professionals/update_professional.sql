DELIMITER $$

CREATE PROCEDURE update_professional(
    IN p_id          INT,
    IN p_name        VARCHAR(255),
    IN p_phone       VARCHAR(50),
    IN p_type        VARCHAR(100),
    IN p_specialty   VARCHAR(100)
)
BEGIN

    IF NOT EXISTS (
        SELECT 1 
        FROM Professional 
        WHERE id = p_id
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Professional not found.';
    END IF;

    IF p_name IS NOT NULL AND TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Professional name is required.';
    END IF;

    IF p_type IS NOT NULL AND TRIM(p_type) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Professional type is required.';
    END IF;

    IF p_phone IS NOT NULL 
       AND p_phone NOT REGEXP '^[0-9]{9}$' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid phone format.';
    END IF;

    UPDATE Professional
    SET
        name       = COALESCE(p_name, name),
        phone      = COALESCE(p_phone, phone),
        type       = COALESCE(p_type, type),
        specialty  = COALESCE(p_specialty, specialty)
    WHERE id = p_id;

    SELECT * 
    FROM Professional 
    WHERE id = p_id;

END$$

DELIMITER ;