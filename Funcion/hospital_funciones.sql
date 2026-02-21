-- ============================================================
-- FUNCION 1
-- Número de médicos dada una especialidad
-- ============================================================

DROP FUNCTION IF EXISTS fn_ContarMedicosPorEspecialidad;

DELIMITER $$
CREATE FUNCTION fn_ContarMedicosPorEspecialidad(
    p_Especialidad VARCHAR(100)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total      INT DEFAULT 0;
    DECLARE msg_error  VARCHAR(500);
    DECLARE cod_error  VARCHAR(10);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            cod_error = RETURNED_SQLSTATE,
            msg_error = MESSAGE_TEXT;
    
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('fn_ContarMedicosPorEspecialidad', 'medico', cod_error, msg_error, NOW());
        SET total = -1;
    END;

    SELECT COUNT(*) INTO total
    FROM medico m
    INNER JOIN especialidad e ON m.cod_especialidad = e.cod_especialidad
    WHERE e.desc_especialidad = p_Especialidad;

    RETURN total;
END$$
DELIMITER ;

-- ============================================================
-- FUNCION 2
-- Total de pacientes atendidos por un médico
-- ============================================================

DROP FUNCTION IF EXISTS fn_TotalPacientesPorMedico;

DELIMITER $$
CREATE FUNCTION fn_TotalPacientesPorMedico(
    p_cod_medico VARCHAR(6)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total      INT DEFAULT 0;
    DECLARE msg_error  VARCHAR(500);
    DECLARE cod_error  VARCHAR(10);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            cod_error = RETURNED_SQLSTATE,
            msg_error = MESSAGE_TEXT;
        
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('fn_TotalPacientesPorMedico', 'cita_clinica', cod_error, msg_error, NOW());
        SET total = -1;
    END;

    SELECT COUNT(DISTINCT cod_paciente) INTO total
    FROM cita_clinica
    WHERE cod_medico = p_cod_medico;

    RETURN total;
END$$
DELIMITER ;

-- ============================================================
-- FUNCION 3
-- Cantidad de pacientes atendidos dada una sede
-- ============================================================

DROP FUNCTION IF EXISTS fn_TotalPacientesPorSede;

DELIMITER $$
CREATE FUNCTION fn_TotalPacientesPorSede(
    p_nom_sede VARCHAR(100)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total      INT DEFAULT 0;
    DECLARE msg_error  VARCHAR(500);
    DECLARE cod_error  VARCHAR(10);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            cod_error = RETURNED_SQLSTATE,
            msg_error = MESSAGE_TEXT;
       
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('fn_TotalPacientesPorSede', 'cita_clinica', cod_error, msg_error, NOW());
        SET total = -1;
    END;

    SELECT COUNT(DISTINCT cc.cod_paciente) INTO total
    FROM cita_clinica cc
    INNER JOIN sede_medica s ON cc.cod_sede = s.cod_sede
    WHERE s.nom_sede = p_nom_sede;

    RETURN total;
END$$
DELIMITER ;

-- ============================================================
-- PRUEBAS DE LAS 3 FUNCIONES
-- ============================================================

-- FUNCION 1: Médicos por especialidad
SELECT fn_ContarMedicosPorEspecialidad('Cardiología')  AS Medicos_Cardiologia;
SELECT fn_ContarMedicosPorEspecialidad('Pediatría')    AS Medicos_Pediatria;
SELECT fn_ContarMedicosPorEspecialidad('Neurología')   AS Medicos_Neurologia;
-- Especialidad que no existe (retorna 0)
SELECT fn_ContarMedicosPorEspecialidad('Infectología') AS Medicos_Infectologia;

-- FUNCION 2: Pacientes por médico
SELECT fn_TotalPacientesPorMedico('MED001') AS Pacientes_Medico1;
SELECT fn_TotalPacientesPorMedico('MED002') AS Pacientes_Medico2;
SELECT fn_TotalPacientesPorMedico('MED003') AS Pacientes_Medico3;
-- Médico que no existe (retorna 0)
SELECT fn_TotalPacientesPorMedico('MED099') AS Pacientes_MedicoInexistente;

-- FUNCION 3: Pacientes por sede
SELECT fn_TotalPacientesPorSede('Sede Norte')  AS Pacientes_SedeNorte;
SELECT fn_TotalPacientesPorSede('Sede Sur')    AS Pacientes_SedeSur;
SELECT fn_TotalPacientesPorSede('Sede Centro') AS Pacientes_SedeCentro;
-- Sede que no existe (retorna 0)
SELECT fn_TotalPacientesPorSede('Sede Oriente') AS Pacientes_SedeInexistente;

-- ============================================================
-- CONSULTA COMPLETA: Médicos con su especialidad y pacientes
-- ============================================================

SELECT
    m.cod_medico,
    m.nom_medico,
    e.desc_especialidad,
    fn_ContarMedicosPorEspecialidad(e.desc_especialidad) AS Total_Medicos_Especialidad,
    fn_TotalPacientesPorMedico(m.cod_medico)             AS Pacientes_Atendidos
FROM medico m
INNER JOIN especialidad e ON m.cod_especialidad = e.cod_especialidad;

-- ============================================================
-- CONSULTA SEDES: Pacientes por cada sede
-- ============================================================

SELECT
    s.cod_sede,
    s.nom_sede,
    s.ubicacion_sede,
    fn_TotalPacientesPorSede(s.nom_sede) AS Total_Pacientes_Atendidos
FROM sede_medica s;

-- ============================================================
-- VER LOGS - Distingue SP de Función
-- ============================================================

SELECT
    log_id,
    nom_rutina,
    CASE
        WHEN nom_rutina LIKE 'sp_%' THEN 'Procedimiento'
        WHEN nom_rutina LIKE 'fn_%' THEN 'Función'
        ELSE 'Desconocido'
    END AS tipo_rutina,
    nom_tabla,
    codigo_error,
    mensaje_error,
    fecha_hora
FROM bitacora_errores
ORDER BY fecha_hora DESC;
