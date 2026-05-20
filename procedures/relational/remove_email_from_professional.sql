DELIMITER $$

CREATE PROCEDURE remove_email_from_professional(
    IN p_professional_id   INT,
    IN p_email VARCHAR(255)
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Professional_Email
        WHERE professional_id = p_professional_id
        AND email = p_email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Relation not found.';
    END IF;

    DELETE
    FROM Professional_Email
    WHERE professional_id = p_professional_id
    AND email = p_email;

END$$

DELIMITER ;