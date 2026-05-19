DELIMITER $$

CREATE PROCEDURE get_episode(
    IN p_id             INT,
    IN p_patient_id     INT,
    IN p_time_from      DATETIME,
    IN p_time_to        DATETIME,
    IN p_status         INT,
    IN p_pulse          FLOAT,
    IN p_sistolic       FLOAT,
    IN p_diastolic      FLOAT,
    IN p_oxygen         FLOAT,
    IN p_temp           FLOAT,
    IN p_breathing      FLOAT
)
BEGIN

    SELECT *
    FROM Episode
    WHERE
        (p_id            IS NULL OR id         = p_id)
    AND (p_patient_id    IS NULL OR patient_id = p_patient_id)
    AND (p_time_from     IS NULL OR time      >= p_time_from)
    AND (p_time_to       IS NULL OR time      <= p_time_to)
    AND (p_status        IS NULL OR status     = p_status)
    AND (p_pulse         IS NULL OR pulse      = p_pulse)
    AND (p_sistolic      IS NULL OR sistolic   = p_sistolic)
    AND (p_diastolic     IS NULL OR diastolic  = p_diastolic)
    AND (p_oxygen        IS NULL OR oxygen     = p_oxygen)
    AND (p_temp          IS NULL OR temp       = p_temp)
    AND (p_breathing     IS NULL OR breathing  = p_breathing);

END$$

DELIMITER ;