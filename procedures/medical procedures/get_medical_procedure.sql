DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE get_medical_procedure(
    IN p_id            INT,
    IN p_location_id   INT,
    IN p_patient_id    INT,
    IN p_time_from     DATETIME,
    IN p_time_to       DATETIME,
    IN p_type          VARCHAR(100),
    IN p_duration      INT
)
SQL SECURITY DEFINER
BEGIN

    SELECT *
    FROM MedicalProcedure
    WHERE
        (p_id            IS NULL OR id          = p_id)
    AND (p_location_id   IS NULL OR location_id = p_location_id)
    AND (p_patient_id    IS NULL OR patient_id  = p_patient_id)
    AND (p_time_from     IS NULL OR time       >= p_time_from)
    AND (p_time_to       IS NULL OR time       <= p_time_to)
    AND (p_type          IS NULL OR type        LIKE CONCAT('%', p_type, '%'))
    AND (p_duration      IS NULL OR duration    = p_duration);

END$$

DELIMITER ;