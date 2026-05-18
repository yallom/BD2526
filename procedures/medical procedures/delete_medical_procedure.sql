DELIMITER $$

CREATE PROCEDURE delete_medical_procedure(
    IN p_id   INT,
    IN p_hard BOOLEAN
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM MedicalProcedure
        WHERE id = p_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Medical procedure not found.';
    END IF;

    IF p_hard THEN

        DELETE
        FROM MedicalProcedure
        WHERE id = p_id;

    ELSE

        UPDATE MedicalProcedure
        SET deleted_at = CURDATE()
        WHERE id = p_id;

        SELECT *
        FROM MedicalProcedure
        WHERE id = p_id;

    END IF;

END$$

DELIMITER ;