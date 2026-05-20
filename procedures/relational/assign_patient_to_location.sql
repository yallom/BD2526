DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE assign_patient_to_location(
    IN p_location_id INT,
    IN p_patient_id  INT
)
SQL SECURITY DEFINER
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Location
        WHERE id = p_location_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Location not found.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Patient
        WHERE id = p_patient_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient not found.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Location_Patient
        WHERE location_id = p_location_id
        AND patient_id = p_patient_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient is already assigned to this location.';
    END IF;

    INSERT INTO Location_Patient (
        location_id,
        patient_id
    )
    VALUES (
        p_location_id,
        p_patient_id
    );

    SELECT *
    FROM Location_Patient
    WHERE location_id = p_location_id
    AND patient_id = p_patient_id;

END$$

DELIMITER ;