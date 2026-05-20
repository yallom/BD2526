DELIMITER $$

CREATE PROCEDURE assign_email_to_professional(
    IN p_professional_id INT,
    IN p_email  VARCHAR(255)
)
BEGIN

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
        FROM Professional_Email
        WHERE email = p_email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already in use';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Patient
        WHERE email = p_email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already in use';
    END IF;
    

    INSERT INTO Professional_Email (
        professional_id,
        email
    )
    VALUES (
        p_professional_id,
        p_email
    );

    SELECT *
    FROM Professional_Email
    WHERE email = p_email;

END$$

DELIMITER ;