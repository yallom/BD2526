DELIMITER $$

CREATE PROCEDURE update_episode(
    IN p_id          INT,
    IN p_patient_id  INT,
    IN p_time        DATETIME,
    IN p_pulse       FLOAT,
    IN p_sistolic    FLOAT,
    IN p_diastolic   FLOAT,
    IN p_oxygen      FLOAT,
    IN p_temp        FLOAT,
    IN p_breathing   FLOAT,
    IN p_status      INT
)
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Episode
        WHERE id = p_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Episode not found.';
    END IF;

    IF p_patient_id IS NOT NULL AND NOT EXISTS (
        SELECT 1
        FROM Patient
        WHERE id = p_patient_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient not found.';
    END IF;

    IF p_pulse IS NOT NULL AND p_pulse < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pulse cannot be negative.';
    END IF;

    IF p_sistolic IS NOT NULL AND p_sistolic < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Systolic pressure cannot be negative.';
    END IF;

    IF p_diastolic IS NOT NULL AND p_diastolic < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Diastolic pressure cannot be negative.';
    END IF;

    IF p_oxygen IS NOT NULL 
       AND (p_oxygen < 0 OR p_oxygen > 100) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Oxygen level must be between 0 and 100.';
    END IF;

    IF p_temp IS NOT NULL 
       AND (p_temp < 20 OR p_temp > 50) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Temperature is outside acceptable range.';
    END IF;

    IF p_breathing IS NOT NULL AND p_breathing < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Breathing rate cannot be negative.';
    END IF;

    UPDATE Episode
    SET
        patient_id = COALESCE(p_patient_id, patient_id),
        time       = COALESCE(p_time, time),
        pulse      = COALESCE(p_pulse, pulse),
        sistolic   = COALESCE(p_sistolic, sistolic),
        diastolic  = COALESCE(p_diastolic, diastolic),
        oxygen     = COALESCE(p_oxygen, oxygen),
        temp       = COALESCE(p_temp, temp),
        breathing  = COALESCE(p_breathing, breathing),
        status     = COALESCE(p_status, status)
    WHERE id = p_id;

    SELECT *
    FROM Episode
    WHERE id = p_id;

END$$

DELIMITER ;