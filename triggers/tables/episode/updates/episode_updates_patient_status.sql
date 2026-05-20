DELIMITER $$
	CREATE TRIGGER update_patient_status
	AFTER INSERT ON Episode
	FOR EACH ROW
	BEGIN
        UPDATE Patient SET status = NEW.status
        WHERE id = NEW.patient_id;
	END$$
DELIMITER ;
		