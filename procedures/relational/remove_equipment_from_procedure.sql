DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE remove_equipment_from_procedure(
    IN p_procedure_id INT,
    IN p_equipment_id INT
)
SQL SECURITY DEFINER
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Procedure_Equipment
        WHERE procedure_id = p_procedure_id
        AND equipment_id = p_equipment_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Relation not found.';
    END IF;

    DELETE
    FROM Procedure_Equipment
    WHERE procedure_id = p_procedure_id
    AND equipment_id = p_equipment_id;

END$$

DELIMITER ;