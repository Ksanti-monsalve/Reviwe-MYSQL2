CREATE DATABASE IF NOT EXISTS sistema_Hospitalario
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_spanish_ci;

USE sistema_Hospitalario;

-- ============================================================
-- 1. TABLAS SIN DEPENDENCIAS (tablas padre)
-- ============================================================

CREATE TABLE especialidad (
    cod_especialidad   VARCHAR(6)   NOT NULL,
    desc_especialidad  VARCHAR(45)  NOT NULL,
    CONSTRAINT pk_especialidad PRIMARY KEY (cod_especialidad)
);

CREATE TABLE departamento (
    cod_departamento   VARCHAR(6)   NOT NULL,
    nom_departamento   VARCHAR(45)  NOT NULL,
    director_depto     VARCHAR(45),
    CONSTRAINT pk_departamento PRIMARY KEY (cod_departamento)
);

CREATE TABLE diagnostico (
    cod_diagnostico    VARCHAR(6)   NOT NULL,
    desc_diagnostico   VARCHAR(255) NOT NULL,
    CONSTRAINT pk_diagnostico PRIMARY KEY (cod_diagnostico)
);

CREATE TABLE paciente (
    cod_paciente       VARCHAR(6)   NOT NULL,
    primer_nombre      VARCHAR(45)  NOT NULL,
    primer_apellido    VARCHAR(45)  NOT NULL,
    num_contacto       VARCHAR(15),
    CONSTRAINT pk_paciente PRIMARY KEY (cod_paciente)
);

CREATE TABLE sede_medica (
    cod_sede           VARCHAR(6)   NOT NULL,
    nom_sede           VARCHAR(45)  NOT NULL,
    ubicacion_sede     VARCHAR(45),
    CONSTRAINT pk_sede_medica PRIMARY KEY (cod_sede)
);

CREATE TABLE medicamento (
    cod_medicamento    VARCHAR(6)   NOT NULL,
    nom_medicamento    VARCHAR(45)  NOT NULL,
    CONSTRAINT pk_medicamento PRIMARY KEY (cod_medicamento)
);

CREATE TABLE bitacora_errores (
    log_id             INT          NOT NULL AUTO_INCREMENT,
    nom_rutina         VARCHAR(100),
    nom_tabla          VARCHAR(100),
    codigo_error       VARCHAR(10),
    mensaje_error      VARCHAR(500),
    fecha_hora         DATETIME,
    CONSTRAINT pk_bitacora PRIMARY KEY (log_id)
);

-- ============================================================
-- 2. TABLA CON DEPENDENCIA A especialidad Y departamento
-- ============================================================

CREATE TABLE medico (
    cod_medico         VARCHAR(6)   NOT NULL,
    nom_medico         VARCHAR(45)  NOT NULL,
    cod_departamento   VARCHAR(6)   NOT NULL,
    cod_especialidad   VARCHAR(6)   NOT NULL,
    CONSTRAINT pk_medico          PRIMARY KEY (cod_medico),
    CONSTRAINT fk_medico_depto    FOREIGN KEY (cod_departamento) REFERENCES departamento(cod_departamento),
    CONSTRAINT fk_medico_esp      FOREIGN KEY (cod_especialidad) REFERENCES especialidad(cod_especialidad)
);

-- ============================================================
-- 3. TABLA CON MÚLTIPLES DEPENDENCIAS
-- ============================================================

CREATE TABLE cita_clinica (
    cod_cita           VARCHAR(6)   NOT NULL,
    fec_cita           DATE         NOT NULL,
    cod_paciente       VARCHAR(6)   NOT NULL,
    cod_medico         VARCHAR(6)   NOT NULL,
    cod_sede           VARCHAR(6)   NOT NULL,
    cod_diagnostico    VARCHAR(6)   NOT NULL,
    CONSTRAINT pk_cita_clinica     PRIMARY KEY (cod_cita),
    CONSTRAINT fk_cita_paciente    FOREIGN KEY (cod_paciente)    REFERENCES paciente(cod_paciente),
    CONSTRAINT fk_cita_medico      FOREIGN KEY (cod_medico)      REFERENCES medico(cod_medico),
    CONSTRAINT fk_cita_sede        FOREIGN KEY (cod_sede)        REFERENCES sede_medica(cod_sede),
    CONSTRAINT fk_cita_diagnostico FOREIGN KEY (cod_diagnostico) REFERENCES diagnostico(cod_diagnostico)
);

-- ============================================================
-- 4. TABLA RECETA (depende de cita_clinica y medicamento)
-- ============================================================

CREATE TABLE receta (
    cod_receta         VARCHAR(6)   NOT NULL,
    dosis_indicada     VARCHAR(45)  NOT NULL,
    cod_medicamento    VARCHAR(6)   NOT NULL,
    cod_cita           VARCHAR(6)   NOT NULL,
    CONSTRAINT pk_receta           PRIMARY KEY (cod_receta),
    CONSTRAINT fk_receta_medic     FOREIGN KEY (cod_medicamento) REFERENCES medicamento(cod_medicamento),
    CONSTRAINT fk_receta_cita      FOREIGN KEY (cod_cita)        REFERENCES cita_clinica(cod_cita)
);

-- ============================================================
-- 5. INSERTS DE DATOS DE EJEMPLO
-- ============================================================

-- especialidad
INSERT INTO especialidad (cod_especialidad, desc_especialidad) VALUES
('ESP001', 'Cardiología'),
('ESP002', 'Pediatría'),
('ESP003', 'Neurología');

-- departamento
INSERT INTO departamento (cod_departamento, nom_departamento, director_depto) VALUES
('DEP001', 'Departamento Clínico', 'Dr. Ramírez'),
('DEP002', 'Departamento Quirúrgico', 'Dra. Torres'),
('DEP003', 'Departamento de Urgencias', 'Dr. Mendoza');

-- diagnostico
INSERT INTO diagnostico (cod_diagnostico, desc_diagnostico) VALUES
('DIA001', 'Hipertensión arterial'),
('DIA002', 'Diabetes mellitus tipo 2'),
('DIA003', 'Migraña crónica');

-- paciente
INSERT INTO paciente (cod_paciente, primer_nombre, primer_apellido, num_contacto) VALUES
('PAC001', 'Carlos', 'Gutiérrez', '3001234567'),
('PAC002', 'Ana', 'Morales', '3109876543'),
('PAC003', 'Luis', 'Herrera', '3205554321');

-- sede_medica
INSERT INTO sede_medica (cod_sede, nom_sede, ubicacion_sede) VALUES
('SED001', 'Sede Norte', 'Av. Carrera 15 #45-20'),
('SED002', 'Sede Sur', 'Calle 80 #10-55'),
('SED003', 'Sede Centro', 'Carrera 7 #32-15');

-- medicamento
INSERT INTO medicamento (cod_medicamento, nom_medicamento) VALUES
('MED001', 'Losartán 50mg'),
('MED002', 'Metformina 850mg'),
('MED003', 'Sumatriptán 100mg');

-- medico
INSERT INTO medico (cod_medico, nom_medico, cod_departamento, cod_especialidad) VALUES
('MED001', 'Dr. Jorge Patiño',    'DEP001', 'ESP001'),
('MED002', 'Dra. Sandra López',   'DEP002', 'ESP002'),
('MED003', 'Dr. Felipe Castillo', 'DEP001', 'ESP003');

-- cita_clinica
INSERT INTO cita_clinica (cod_cita, fec_cita, cod_paciente, cod_medico, cod_sede, cod_diagnostico) VALUES
('CIT001', '2025-01-10', 'PAC001', 'MED001', 'SED001', 'DIA001'),
('CIT002', '2025-01-15', 'PAC002', 'MED002', 'SED002', 'DIA002'),
('CIT003', '2025-02-03', 'PAC003', 'MED003', 'SED003', 'DIA003');

-- receta
INSERT INTO receta (cod_receta, dosis_indicada, cod_medicamento, cod_cita) VALUES
('REC001', '1 tableta cada 12 horas', 'MED001', 'CIT001'),
('REC002', '1 tableta después de cada comida', 'MED002', 'CIT002'),
('REC003', '1 tableta al inicio del dolor', 'MED003', 'CIT003');

-- bitacora_errores (registro de ejemplo)
INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora) VALUES
('sp_registrar_cita', 'cita_clinica', 'ERR001', 'Paciente no encontrado en el sistema', '2025-01-10 09:30:00');