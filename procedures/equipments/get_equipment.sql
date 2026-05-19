DELIMITER $$

CREATE PROCEDURE get_equipment(
    IN p_id              INT,
    IN p_serial_number   VARCHAR(100),
    IN p_brand           VARCHAR(100),
    IN p_model           VARCHAR(100),
    IN p_category        VARCHAR(100),
    IN p_state           ENUM('available', 'unavailable', 'maintenance', 'inoperable'),
    IN p_use_time        INT,
    IN p_last_repair_from DATETIME,
    IN p_last_repair_to   DATETIME,
    IN p_next_repair_from DATETIME,
    IN p_next_repair_to   DATETIME
)
BEGIN

    SELECT *
    FROM Equipment
    WHERE
        (p_id                IS NULL OR id             = p_id)
    AND (p_serial_number     IS NULL OR serial_number  = p_serial_number)
    AND (p_brand             IS NULL OR brand          LIKE CONCAT('%', p_brand, '%'))
    AND (p_model             IS NULL OR model          LIKE CONCAT('%', p_model, '%'))
    AND (p_category          IS NULL OR category       LIKE CONCAT('%', p_category, '%'))
    AND (p_state             IS NULL OR state          = p_state)
    AND (p_use_time          IS NULL OR use_time       = p_use_time)
    AND (p_last_repair_from  IS NULL OR last_repair   >= p_last_repair_from)
    AND (p_last_repair_to    IS NULL OR last_repair   <= p_last_repair_to)
    AND (p_next_repair_from  IS NULL OR next_repair   >= p_next_repair_from)
    AND (p_next_repair_to    IS NULL OR next_repair   <= p_next_repair_to);

END$$

DELIMITER ;