DROP DATABASE hospital_db;
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- -----------------------------------------------------
-- Table: Patient
-- -----------------------------------------------------
CREATE TABLE Patient (
    id            INT AUTO_INCREMENT  NOT NULL,
    name          VARCHAR(255) NOT NULL,
    email         VARCHAR(255),
    phone         VARCHAR(50),
    nif           VARCHAR(20),
    birthdate     DATETIME,
    gender        ENUM('male', 'female') NOT NULL,
    height        INT,
    weight        INT,
    blood_type    ENUM('A-','A+','B-','B+','AB-','AB+','O-','O+') NOT NULL,
    status		  INT NOT NULL DEFAULT 0,
    created_at	  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at	  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at    DATETIME DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE (email),
    UNIQUE (phone),
    UNIQUE (nif)
);

-- -----------------------------------------------------
-- Table: Professional
-- -----------------------------------------------------
CREATE TABLE Professional (
    id            INT AUTO_INCREMENT  NOT NULL,
    name          VARCHAR(255) NOT NULL,
    email         VARCHAR(255),
    phone         VARCHAR(50),
    type          VARCHAR(100),
    specialty     VARCHAR(100),
    created_at	  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at	  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at    DATETIME DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE (email),
    UNIQUE (phone)
);

-- -----------------------------------------------------
-- Table: Equipment
-- -----------------------------------------------------
CREATE TABLE Equipment (
    id             INT AUTO_INCREMENT  NOT NULL,
    serial_number  VARCHAR(100),
    brand          VARCHAR(100),
    model          VARCHAR(100),
    category       VARCHAR(100),
    state          ENUM('available', 'unavailable', 'maintenance', 'inoperable') NOT NULL,
    use_time       INT,
    last_repair    DATETIME,
    next_repair    DATETIME,
    created_at	  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at	  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at    DATETIME DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE (serial_number)
);

-- -----------------------------------------------------
-- Table: location
-- -----------------------------------------------------
CREATE TABLE Location (
    id      INT AUTO_INCREMENT NOT NULL,
    type    ENUM('room','operating_room','emergency','examination')
    number  INT,
    floor   INT,
    state   ENUM('available', 'unavailable', 'maintenance', 'inoperable') NOT NULL,
    created_at	  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at	  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at    DATETIME DEFAULT NULL,
    PRIMARY KEY (id)
);

-- -----------------------------------------------------
-- Junction: location <-> Patient (patients string[])
-- -----------------------------------------------------
CREATE TABLE Location_Patient (
    location_id     INT NOT NULL,
    patient_id  INT NOT NULL,
    PRIMARY KEY (location_id, patient_id),
    FOREIGN KEY (location_id)    REFERENCES Location(id)    ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES Patient(id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: Procedure
-- -----------------------------------------------------
CREATE TABLE MedicalProcedure (
    id          INT AUTO_INCREMENT  NOT NULL,
    location_id     INT,
    patient_id  INT,
    time        DATETIME,
    type        VARCHAR(100),
    duration    INT,
    created_at	  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at	  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at    DATETIME DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (location_id)    REFERENCES Location(id)    ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES Patient(id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Junction: Procedure <-> Professional
-- -----------------------------------------------------
CREATE TABLE Procedure_Professional (
    procedure_id     INT NOT NULL,
    professional_id  INT NOT NULL,
    PRIMARY KEY (procedure_id, professional_id),
    FOREIGN KEY (procedure_id)    REFERENCES MedicalProcedure(id)    ON DELETE CASCADE,
    FOREIGN KEY (professional_id) REFERENCES Professional(id) 		 ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Junction: Procedure <-> Equipment
-- -----------------------------------------------------
CREATE TABLE Procedure_Equipment (
    procedure_id  INT NOT NULL,
    equipment_id  INT NOT NULL,
    PRIMARY KEY (procedure_id, equipment_id),
    FOREIGN KEY (procedure_id)  REFERENCES MedicalProcedure(id)  ON DELETE CASCADE,
    FOREIGN KEY (equipment_id)  REFERENCES Equipment(id)  ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: Episode
-- -----------------------------------------------------
CREATE TABLE Episode (
    id             INT AUTO_INCREMENT NOT NULL,
    patient_id     INT,
    time           DATETIME,
    pulse          FLOAT,
    sistolic       FLOAT,
    diastolic      FLOAT,
    oxygen         FLOAT,
    temp           FLOAT,
    breathing      FLOAT,
    status         INT,
    created_at	  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at	  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at    DATETIME DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (patient_id) REFERENCES Patient(id) ON DELETE SET NULL
);

-- -----------------------------------------------------
-- Junction: Episode <-> Professional
-- -----------------------------------------------------
CREATE TABLE Episode_Professional (
    episode_id           INT NOT NULL,
    professional_id  INT NOT NULL,
    PRIMARY KEY (episode_id, professional_id),
    FOREIGN KEY (episode_id)          REFERENCES Episode(id)      ON DELETE CASCADE,
    FOREIGN KEY (professional_id) REFERENCES Professional(id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Junction: Episode <-> Equipment
-- -----------------------------------------------------
CREATE TABLE Episode_Equipment (
    episode_id        INT NOT NULL,
    equipment_id  INT NOT NULL,
    PRIMARY KEY (episode_id, equipment_id),
    FOREIGN KEY (episode_id)       REFERENCES Episode(id)   ON DELETE CASCADE,
    FOREIGN KEY (equipment_id) REFERENCES Equipment(id) ON DELETE CASCADE
);

-- ---------------------------
-- ALERTS
-- ---------------------------

CREATE TABLE Alert (
	id 					INT AUTO_INCREMENT NOT NULL,
    entity_type 		ENUM('patient','professional','equipment','location','procedure','episode') NOT NULL,
    entity_id			INT NOT NULL,
    severity			ENUM('info','warning','critical') DEFAULT 'warning',
    reason 				VARCHAR(100),
    message 			VARCHAR(255) NOT NULL,
    resolved_at			DATETIME DEFAULT NULL,
    timestamp   		DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);