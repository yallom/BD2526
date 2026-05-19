DELIMITER $$

CREATE PROCEDURE assign_professional_to_procedure(
    IN p_procedure_id    INT,
    IN p_professional_id INT
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM MedicalProcedure
        WHERE id = p_procedure_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Procedure not found.';
    END IF;

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
        FROM Procedure_Professional
        WHERE procedure_id = p_procedure_id
        AND professional_id = p_professional_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Professional already assigned to procedure.';
    END IF;

    INSERT INTO Procedure_Professional (
        procedure_id,
        professional_id
    )
    VALUES (
        p_procedure_id,
        p_professional_id
    );

    SELECT *
    FROM Procedure_Professional
    WHERE procedure_id = p_procedure_id
    AND professional_id = p_professional_id;

END$$

DELIMITER ;