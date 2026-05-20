DELIMITER $$

CREATE PROCEDURE get_professional(
    IN p_id          INT,
    IN p_name        VARCHAR(255),
    IN p_email       VARCHAR(255),
    IN p_phone       VARCHAR(50),
    IN p_type        VARCHAR(100),
    IN p_specialty   VARCHAR(100)
)
BEGIN

    SELECT p.*, pe.email
    FROM Professional p
    LEFT JOIN Professional_Email pe ON pe.professional_id = p.id 
    WHERE
        (p_id         IS NULL OR p.id         = p_id)
    AND (p_name       IS NULL OR p.name       LIKE CONCAT('%', p_name, '%'))
    AND (p_phone      IS NULL OR p.phone      = p_phone)
    AND (p_type       IS NULL OR p.type       = p_type)
    AND (p_specialty  IS NULL OR p.specialty  = p_specialty)
    AND (p_email	  IS NULL OR pe.email	  LIKE CONCAT('%', p_email, '%'));

END$$

DELIMITER ; 