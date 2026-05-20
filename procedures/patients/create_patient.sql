DELIMITER $$
CREATE DEFINER='app_admin'@'localhost' PROCEDURE create_patient(
    IN p_name       VARCHAR(255),
    IN p_email      VARCHAR(255),
    IN p_phone      VARCHAR(50),
    IN p_nif        VARCHAR(20),
    IN p_birthdate  DATETIME,
    IN p_gender     ENUM('male','female'),
    IN p_height     INT,
    IN p_weight     INT,
    IN p_blood_type ENUM('A-','A+','B-','B+','AB-','AB+','O-','O+')
)
SQL SECURITY DEFINER
BEGIN

    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Patient name is required.';
    END IF;

    IF p_gender IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Gender is required.';
    END IF;

    IF p_blood_type IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Blood type is required.';
    END IF;

    IF p_height IS NOT NULL AND p_height NOT BETWEEN 30 AND 300 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Height must be between 30 and 300 cm.';
    END IF;

    IF p_weight IS NOT NULL AND p_weight NOT BETWEEN 1 AND 700 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Weight must be between 1 and 700 kg.';
    END IF;
    
    IF p_email IS NOT NULL AND p_email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'E-mail format invalid.';
	END IF;
    
    IF p_phone IS NOT NULL AND p_phone NOT REGEXP '^[0-9]{9}$' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid phone format.';
	END IF;

	IF p_nif IS NOT NULL AND p_nif NOT REGEXP '^[0-9]{9}$' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIF must be 9 digits.';
	END IF;

	IF p_birthdate IS NOT NULL AND p_birthdate < DATE_SUB(CURDATE(), INTERVAL 130 YEAR) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Birthdate is outside acceptable range.';
	END IF;
    
    IF p_birthdate IS NOT NULL AND p_birthdate > CURDATE() THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Birthdate is outside acceptable range.';
	END IF;

    INSERT INTO Patient (name, email, phone, nif, birthdate, gender, height, weight, blood_type)
    VALUES (p_name, p_email, p_phone, p_nif, p_birthdate, p_gender, p_height, p_weight, p_blood_type);

    SELECT * FROM Patient WHERE id = LAST_INSERT_ID();
    
END$$
DELIMITER ;