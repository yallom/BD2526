DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE assign_equipment_to_procedure(
    IN p_procedure_id INT,
    IN p_equipment_id INT
)
SQL SECURITY DEFINER
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
        FROM Equipment
        WHERE id = p_equipment_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment not found.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Procedure_Equipment
        WHERE procedure_id = p_procedure_id
        AND equipment_id = p_equipment_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment already assigned to procedure.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Equipment
        WHERE id = p_equipment_id
        AND state IN ('maintenance', 'inoperable')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment is unavailable.';
    END IF;

    INSERT INTO Procedure_Equipment (
        procedure_id,
        equipment_id
    )
    VALUES (
        p_procedure_id,
        p_equipment_id
    );

    SELECT *
    FROM Procedure_Equipment
    WHERE procedure_id = p_procedure_id
    AND equipment_id = p_equipment_id;

END$$

DELIMITER ;