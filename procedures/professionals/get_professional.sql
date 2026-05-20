DELIMITER $$

CREATE DEFINER='app_admin'@'localhost' PROCEDURE get_professional(
    IN p_id          INT,
    IN p_name        VARCHAR(255),
    IN p_email       VARCHAR(255),
    IN p_phone       VARCHAR(50),
    IN p_type        VARCHAR(100),
    IN p_specialty   VARCHAR(100)
)
SQL SECURITY DEFINER
BEGIN

    SELECT *
    FROM Professional
    WHERE
        (p_id         IS NULL OR id         = p_id)
    AND (p_name       IS NULL OR name       LIKE CONCAT('%', p_name, '%'))
    AND (p_email      IS NULL OR email      = p_email)
    AND (p_phone      IS NULL OR phone      = p_phone)
    AND (p_type       IS NULL OR type       = p_type)
    AND (p_specialty  IS NULL OR specialty  = p_specialty);

END$$

DELIMITER ;