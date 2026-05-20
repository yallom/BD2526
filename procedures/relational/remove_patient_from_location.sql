DELIMITER $$

CREATE PROCEDURE remove_patient_from_location(
    IN p_location_id INT,
    IN p_patient_id  INT
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Location_Patient
        WHERE location_id = p_location_id
        AND patient_id = p_patient_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Relation not found.';
    END IF;

    DELETE
    FROM Location_Patient
    WHERE location_id = p_location_id
    AND patient_id = p_patient_id;

END$$

DELIMITER ;