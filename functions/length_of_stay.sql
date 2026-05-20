DELIMITER $$
 
CREATE FUNCTION fn_length_of_stay(patient_id INT)
 
RETURNS INT
READS SQL DATA
 
BEGIN
    DECLARE admitted_at DATETIME;
 
    SELECT MIN(arrived_at) INTO admitted_at
    FROM Location_Patient
    WHERE Location_Patient.patient_id = patient_id
      AND left_at IS NULL;
 
    IF admitted_at IS NULL THEN
        RETURN NULL;
    END IF;
 
    RETURN DATEDIFF(NOW(), admitted_at);
 
END$$
 
DELIMITER;
