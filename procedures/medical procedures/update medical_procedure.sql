DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE update_medical_procedure(
    IN p_id            INT,
    IN p_location_id   INT,
    IN p_patient_id    INT,
    IN p_time          DATETIME,
    IN p_type          VARCHAR(100),
    IN p_duration      INT
)
SQL SECURITY DEFINER
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM MedicalProcedure
        WHERE id = p_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Medical procedure not found.';
    END IF;

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

    IF p_type IS NOT NULL AND TRIM(p_type) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Procedure type cannot be empty.';
    END IF;

    IF p_duration IS NOT NULL AND p_duration <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duration must be greater than zero.';
    END IF;

    UPDATE MedicalProcedure
    SET
        location_id = COALESCE(p_location_id, location_id),
        patient_id  = COALESCE(p_patient_id, patient_id),
        time        = COALESCE(p_time, time),
        type        = COALESCE(p_type, type),
        duration    = COALESCE(p_duration, duration)
    WHERE id = p_id;

    SELECT *
    FROM MedicalProcedure
    WHERE id = p_id;

END$$

DELIMITER ;