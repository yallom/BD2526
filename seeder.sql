USE hospital_db;

-- -----------------------------------------------------
-- Patients
-- -----------------------------------------------------
INSERT INTO Patient (name, email, phone, nif, birthdate, gender, height, weight, blood_type, status) VALUES
('Ana Sousa',       'ana.sousa@email.com',   '+351910000001', '123456789', '1985-03-12', 'female', 165, 60, 'A+',  1),
('Carlos Ferreira', 'carlos.f@email.com',    '+351910000002', '234567890', '1972-07-24', 'male',   178, 85, 'O-',  1),
('Maria Oliveira',  'maria.o@email.com',     '+351910000003', '345678901', '1990-11-05', 'female', 160, 55, 'B+',  0),
('João Martins',    'joao.m@email.com',      '+351910000004', '456789012', '1965-01-30', 'male',   172, 90, 'AB+', 1),
('Sofia Lopes',     'sofia.l@email.com',     '+351910000005', '567890123', '2000-06-18', 'female', 170, 65, 'O+',  1);
-- IDs will be 1..5

-- -----------------------------------------------------
-- Professionals
-- -----------------------------------------------------
INSERT INTO Professional (name, email, phone, type, specialty) VALUES
('Dr. Rui Costa',      'rui.costa@hospital.com',  '+351920000001', 'doctor', 'cardiology'),
('Dr. Inês Nunes',     'ines.nunes@hospital.com', '+351920000002', 'doctor', 'neurology'),
('Enf. Pedro Gomes',   'pedro.g@hospital.com',    '+351920000003', 'nurse',  NULL),
('Enf. Beatriz Silva', 'beatriz.s@hospital.com',  '+351920000004', 'nurse',  NULL),
('Dr. Tiago Mendes',   'tiago.m@hospital.com',    '+351920000005', 'doctor', 'surgery');
-- IDs will be 1..5

-- -----------------------------------------------------
-- Equipment
-- -----------------------------------------------------
INSERT INTO Equipment (serial_number, brand, model, category, state, use_time, last_repair, next_repair) VALUES
('SN-001', 'Philips', 'MX450',    'monitor',    'available',   1200, '2025-01-10', '2026-01-10'),
('SN-002', 'GE',      'Optima',   'mri',        'available',   3400, '2025-03-15', '2026-03-15'),
('SN-003', 'Siemens', 'SC7000',   'ventilator', 'available',  800, '2025-06-01', '2026-06-01'),
('SN-004', 'Mindray', 'DC-70',    'ultrasound', 'available',    500, '2025-09-20', '2026-09-20'),
('SN-005', 'Dräger',  'Infinity', 'monitor',    'available',   2100, '2025-11-05', '2026-11-05');
-- IDs will be 1..5

-- -----------------------------------------------------
-- Locations
-- -----------------------------------------------------
INSERT INTO Location (number, floor, state) VALUES
(101, 1, 'available'),
(102, 1, 'available'),
(201, 2, 'available'),
(202, 2, 'available'),
(301, 3, 'available');
-- IDs will be 1..5

-- -----------------------------------------------------
-- Location <-> Patient
-- -----------------------------------------------------
INSERT INTO Location_Patient (location_id, patient_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(4, 4),
(4, 5);

-- -----------------------------------------------------
-- MedicalProcedures
-- -----------------------------------------------------
INSERT INTO MedicalProcedure (location_id, patient_id, time, type, duration) VALUES
(1, 1, '2026-04-01 09:00:00', 'consultation',  30),
(2, 2, '2026-04-02 10:30:00', 'surgery',      120),
(4, 3, '2026-04-03 14:00:00', 'exam',          45),
(1, 4, '2026-04-04 08:00:00', 'surgery',       90),
(2, 5, '2026-04-05 11:00:00', 'consultation',  20);
-- IDs will be 1..5

-- -----------------------------------------------------
-- Procedure <-> Professional
-- -----------------------------------------------------
INSERT INTO Procedure_Professional (procedure_id, professional_id) VALUES
(1, 1),
(2, 5),
(2, 3),
(3, 2),
(4, 5),
(4, 4),
(5, 1);

-- -----------------------------------------------------
-- Procedure <-> Equipment
-- -----------------------------------------------------
INSERT INTO Procedure_Equipment (procedure_id, equipment_id) VALUES
(1, 1),
(2, 3),
(3, 4),
(4, 2),
(5, 5);

-- -----------------------------------------------------
-- UCI Logs
-- -----------------------------------------------------
INSERT INTO Episode (patient_id, time, pulse, sistolic, diastolic, oxygen, temp, breathing, status) VALUES
(1, '2026-04-01 09:30:00', 72.0, 120.0, 80.0, 98.0, 36.6, 16.0, 1),
(2, '2026-04-02 11:00:00', 88.0, 145.0, 95.0, 95.0, 37.1, 20.0, 2),
(3, '2026-04-03 14:30:00', 65.0, 110.0, 70.0, 99.0, 36.4, 14.0, 1),
(4, '2026-04-04 08:30:00', 95.0, 160.0, 100.0, 93.0, 38.2, 22.0, 3),
(5, '2026-04-05 11:30:00', 70.0, 118.0, 76.0, 97.0, 36.7, 15.0, 1);
-- IDs will be 1..5

-- -----------------------------------------------------
-- Episode <-> Professional
-- -----------------------------------------------------
INSERT INTO Episode_Professional (episode_id, professional_id) VALUES
(1, 3),
(2, 1),
(3, 4),
(4, 2),
(5, 3);

-- -----------------------------------------------------
-- Episode <-> Equipment
-- -----------------------------------------------------
INSERT INTO Episode_Equipment (episode_id, equipment_id) VALUES
(1, 1),
(2, 5),
(3, 1),
(4, 5),
(5, 4);