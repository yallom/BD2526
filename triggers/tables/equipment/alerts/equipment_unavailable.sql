DELIMITER $$
CREATE TRIGGER equipment_unavailable
AFTER UPDATE ON Equipment
FOR EACH ROW
BEGIN
    DECLARE v_message VARCHAR(255);

    IF OLD.state = 'available' AND NEW.state != 'available' THEN
        SET v_message = CONCAT('Equipment ', NEW.id, ' changed state from available to ', NEW.state, '.');
        INSERT INTO Alert (entity_type, entity_id, reason, message, severity)
        VALUES (
            'equipment',
            NEW.id,
            CASE NEW.state
                WHEN 'maintenance'  THEN 'maintenance'
                WHEN 'unavailable'  THEN 'in-use'
                WHEN 'inoperable'   THEN 'broken'
            END,
            v_message,
            CASE NEW.state
                WHEN 'maintenance'  THEN 'warning'
                WHEN 'unavailable'  THEN 'warning'
                WHEN 'inoperable'   THEN 'critical'
            END
        );
    END IF;

END$$
DELIMITER ;