DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE get_location(
    IN p_id      INT,
    IN p_number  INT,
    IN p_floor   INT,
    IN p_state   ENUM('available', 'unavailable', 'maintenance', 'inoperable')
)
SQL SECURITY DEFINER
BEGIN

    SELECT *
    FROM Location
    WHERE
        (p_id      IS NULL OR id     = p_id)
    AND (p_number  IS NULL OR number = p_number)
    AND (p_floor   IS NULL OR floor  = p_floor)
    AND (p_state   IS NULL OR state  = p_state);

END$$

DELIMITER ;