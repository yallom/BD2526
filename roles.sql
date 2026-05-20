-- Create roles
CREATE ROLE 'admin_role', 'doctor_role', 'nurse_role', 'receptionist_role';

-- Create one DB user per role (these are your app's connection accounts)
CREATE USER 'app_admin'@'localhost'       IDENTIFIED BY 'strong_password';
CREATE USER 'app_doctor'@'localhost'      IDENTIFIED BY 'strong_password';
CREATE USER 'app_nurse'@'localhost'       IDENTIFIED BY 'strong_password';
CREATE USER 'app_receptionist'@'localhost'IDENTIFIED BY 'strong_password';

-- Assign roles to users
GRANT admin_role        TO 'app_admin'@'localhost';
GRANT doctor_role       TO 'app_doctor'@'localhost';
GRANT nurse_role        TO 'app_nurse'@'localhost';
GRANT receptionist_role TO 'app_receptionist'@'localhost';


---------------------------
------- Privilleges -------
---------------------------


-- ─────────────────────────────────────
-- Admin
-- ─────────────────────────────────────
GRANT ALL PRIVILEGES ON hospital_db.* TO 'admin_role';

-- ─────────────────────────────────────
-- Doctor
-- ─────────────────────────────────────
GRANT EXECUTE ON PROCEDURE hospital_db.get_patient                  TO 'doctor_role';
GRANT EXECUTE ON PROCEDURE hospital_db.get_episode                  TO 'doctor_role';
GRANT EXECUTE ON PROCEDURE hospital_db.get_equipment                TO 'doctor_role';
GRANT EXECUTE ON PROCEDURE hospital_db.get_location                 TO 'doctor_role';
GRANT EXECUTE ON PROCEDURE hospital_db.get_medical_procedure        TO 'doctor_role';
GRANT EXECUTE ON PROCEDURE hospital_db.create_episode               TO 'doctor_role';
GRANT EXECUTE ON PROCEDURE hospital_db.update_episode               TO 'doctor_role';
GRANT EXECUTE ON PROCEDURE hospital_db.create_medical_procedure     TO 'doctor_role';
GRANT EXECUTE ON PROCEDURE hospital_db.assign_professional_to_episode    TO 'doctor_role';
GRANT EXECUTE ON PROCEDURE hospital_db.assign_equipment_to_episode  TO 'doctor_role';

-- ─────────────────────────────────────
-- Nurse
-- ─────────────────────────────────────
GRANT EXECUTE ON PROCEDURE hospital_db.get_patient                  TO 'nurse_role';
GRANT EXECUTE ON PROCEDURE hospital_db.get_episode                  TO 'nurse_role';
GRANT EXECUTE ON PROCEDURE hospital_db.update_episode               TO 'nurse_role';

-- ─────────────────────────────────────
-- Receptionist
-- ─────────────────────────────────────
GRANT EXECUTE ON PROCEDURE hospital_db.get_patient                  TO 'receptionist_role';
GRANT EXECUTE ON PROCEDURE hospital_db.get_location                 TO 'receptionist_role';
GRANT EXECUTE ON PROCEDURE hospital_db.create_patient               TO 'receptionist_role';
GRANT EXECUTE ON PROCEDURE hospital_db.update_patient               TO 'receptionist_role';
GRANT EXECUTE ON PROCEDURE hospital_db.assign_patient_to_location   TO 'receptionist_role';
GRANT EXECUTE ON PROCEDURE hospital_db.remove_patient_from_location TO 'receptionist_role';

-- ─────────────────────────────────────
-- Technician
-- ─────────────────────────────────────
GRANT EXECUTE ON PROCEDURE hospital_db.get_equipment                TO 'technician_role';
GRANT EXECUTE ON PROCEDURE hospital_db.update_equipment             TO 'technician_role';