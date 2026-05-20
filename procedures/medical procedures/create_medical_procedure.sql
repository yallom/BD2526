DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE create_medical_procedure(
    IN p_location_id INT,
    IN p_patient_id  INT,
    IN p_time        DATETIME,
    IN p_type        VARCHAR(100),
    IN p_duration    INT
)
SQL SECURITY DEFINER
BEGIN

    IF p_location_id IS NOT NULL AND NOT EXISTS (
        SELECT 1
        FROM Location
        WHERE id = p_location_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Location not found.';
    END IF;

    IF p_patient_id IS NOT NULL AND NOT EXISTS (
        SELECT 1
        FROM Patient
        WHERE id = p_patient_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient not found.';
    END IF;

    IF p_type IS NULL OR TRIM(p_type) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Procedure type is required.';
    END IF;

    IF p_duration IS NOT NULL AND p_duration <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duration must be greater than zero.';
    END IF;

    INSERT INTO MedicalProcedure (
        location_id,
        patient_id,
        time,
        type,
        duration
    )
    VALUES (
        p_location_id,
        p_patient_id,
        p_time,
        p_type,
        p_duration
    );

    SELECT *
    FROM MedicalProcedure
    WHERE id = LAST_INSERT_ID();

END$$

DELIMITER ;