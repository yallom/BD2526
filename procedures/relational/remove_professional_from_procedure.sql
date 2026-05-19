DELIMITER $$

CREATE PROCEDURE remove_professional_from_procedure(
    IN p_procedure_id    INT,
    IN p_professional_id INT
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Procedure_Professional
        WHERE procedure_id = p_procedure_id
        AND professional_id = p_professional_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Relation not found.';
    END IF;

    DELETE
    FROM Procedure_Professional
    WHERE procedure_id = p_procedure_id
    AND professional_id = p_professional_id;

END$$

DELIMITER ;