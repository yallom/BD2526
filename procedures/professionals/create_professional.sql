DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE create_professional(
    IN p_name       VARCHAR(255),
    IN p_email      VARCHAR(255),
    IN p_phone      VARCHAR(50),
    IN p_type       VARCHAR(100),
    IN p_specialty  VARCHAR(100)
)
SQL SECURITY DEFINER
BEGIN

    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Professional name is required.';
    END IF;

    IF p_type IS NULL OR TRIM(p_type) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Professional type is required.';
    END IF;

    IF p_email IS NOT NULL 
       AND p_email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'E-mail format invalid.';
    END IF;

    IF p_phone IS NOT NULL 
       AND p_phone NOT REGEXP '^[0-9]{9}$' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid phone format.';
    END IF;

    INSERT INTO Professional (
        name,
        email,
        phone,
        type,
        specialty
    )
    VALUES (
        p_name,
        p_email,
        p_phone,
        p_type,
        p_specialty
    );

    SELECT * 
    FROM Professional 
    WHERE id = LAST_INSERT_ID();

END$$

DELIMITER ;