DELIMITER $$
 
CREATE FUNCTION fn_bmi(weight INT, height INT)
 
RETURNS FLOAT
DETERMINISTIC
 
BEGIN
    IF height IS NULL OR height = 0 OR weight IS NULL THEN
        RETURN NULL;
    END IF;
 
    RETURN ROUND(weight / POW(height / 100.0, 2), 1);
 
END$$
 
DELIMITER;