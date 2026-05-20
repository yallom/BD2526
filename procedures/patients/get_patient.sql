DELIMITER $$
CREATE PROCEDURE get_patient(
    IN p_id             INT,
    IN p_name           VARCHAR(255),
    IN p_address        VARCHAR(255),
    IN p_email          VARCHAR(255),
    IN p_phone          VARCHAR(50),
    IN p_nif            VARCHAR(20),
    IN p_gender         ENUM('male','female'),
    IN p_blood_type     ENUM('A-','A+','B-','B+','AB-','AB+','O-','O+'),
    IN p_status         INT,
    IN p_height         INT,
    IN p_weight         INT,
    IN p_birthdate_from DATETIME,
    IN p_birthdate_to   DATETIME
)
BEGIN
    SELECT * FROM Patient
    WHERE
        (p_id             IS NULL OR id         = p_id)
    AND (p_name           IS NULL OR name       LIKE CONCAT('%', p_name, '%'))
    AND (p_address        IS NULL OR address    LIKE CONCAT('%', p_address, '%'))
    AND (p_email          IS NULL OR email      LIKE CONCAT('%', p_email, '%'))
    AND (p_phone          IS NULL OR phone      = p_phone)
    AND (p_nif            IS NULL OR nif        = p_nif)
    AND (p_gender         IS NULL OR gender     = p_gender)
    AND (p_blood_type     IS NULL OR blood_type = p_blood_type)
    AND (p_status         IS NULL OR status     = p_status)
    AND (p_height         IS NULL OR height     = p_height)
    AND (p_weight         IS NULL OR weight     = p_weight)
    AND (p_birthdate_from IS NULL OR birthdate >= p_birthdate_from)
    AND (p_birthdate_to   IS NULL OR birthdate <= p_birthdate_to);
END$$
DELIMITER ;