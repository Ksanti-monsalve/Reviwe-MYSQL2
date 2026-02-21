-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: cita_clinica
-- (Equivalente a CONSULTA_MEDICA del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarCitaClinica$$
CREATE PROCEDURE sp_InsertarCitaClinica(
    IN p_cod_cita        VARCHAR(6),
    IN p_fec_cita        DATE,
    IN p_cod_paciente    VARCHAR(6),
    IN p_cod_medico      VARCHAR(6),
    IN p_cod_diagnostico VARCHAR(6),
    IN p_cod_sede        VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_InsertarCitaClinica', 'cita_clinica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    INSERT INTO cita_clinica (cod_cita, fec_cita, cod_paciente, cod_medico, cod_diagnostico, cod_sede)
    VALUES (p_cod_cita, p_fec_cita, p_cod_paciente, p_cod_medico, p_cod_diagnostico, p_cod_sede);
    SELECT 'Cita clínica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCitasClinicas$$
CREATE PROCEDURE sp_ObtenerCitasClinicas()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerCitasClinicas', 'cita_clinica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT
        cc.cod_cita,
        cc.fec_cita,
        cc.cod_paciente,
        CONCAT(p.primer_nombre, ' ', p.primer_apellido) AS nombre_completo_paciente,
        cc.cod_medico,
        m.nom_medico,
        e.desc_especialidad,
        d.desc_diagnostico,
        cc.cod_sede,
        s.nom_sede,
        s.ubicacion_sede
    FROM cita_clinica cc
    INNER JOIN paciente      p  ON cc.cod_paciente    = p.cod_paciente
    INNER JOIN medico        m  ON cc.cod_medico       = m.cod_medico
    INNER JOIN especialidad  e  ON m.cod_especialidad  = e.cod_especialidad
    INNER JOIN diagnostico   d  ON cc.cod_diagnostico  = d.cod_diagnostico
    INNER JOIN sede_medica   s  ON cc.cod_sede         = s.cod_sede;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCitaClinicaPorID$$
CREATE PROCEDURE sp_ObtenerCitaClinicaPorID(
    IN p_cod_cita VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerCitaClinicaPorID', 'cita_clinica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT
        cc.cod_cita,
        cc.fec_cita,
        cc.cod_paciente,
        CONCAT(p.primer_nombre, ' ', p.primer_apellido) AS nombre_completo_paciente,
        cc.cod_medico,
        m.nom_medico,
        e.desc_especialidad,
        d.desc_diagnostico,
        cc.cod_sede,
        s.nom_sede,
        s.ubicacion_sede
    FROM cita_clinica cc
    INNER JOIN paciente      p  ON cc.cod_paciente    = p.cod_paciente
    INNER JOIN medico        m  ON cc.cod_medico       = m.cod_medico
    INNER JOIN especialidad  e  ON m.cod_especialidad  = e.cod_especialidad
    INNER JOIN diagnostico   d  ON cc.cod_diagnostico  = d.cod_diagnostico
    INNER JOIN sede_medica   s  ON cc.cod_sede         = s.cod_sede
    WHERE cc.cod_cita = p_cod_cita;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarCitaClinica$$
CREATE PROCEDURE sp_ActualizarCitaClinica(
    IN p_cod_cita        VARCHAR(6),
    IN p_fec_cita        DATE,
    IN p_cod_paciente    VARCHAR(6),
    IN p_cod_medico      VARCHAR(6),
    IN p_cod_diagnostico VARCHAR(6),
    IN p_cod_sede        VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ActualizarCitaClinica', 'cita_clinica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    UPDATE cita_clinica
    SET fec_cita        = p_fec_cita,
        cod_paciente    = p_cod_paciente,
        cod_medico      = p_cod_medico,
        cod_diagnostico = p_cod_diagnostico,
        cod_sede        = p_cod_sede
    WHERE cod_cita = p_cod_cita;
    SELECT 'Cita clínica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarCitaClinica$$
CREATE PROCEDURE sp_EliminarCitaClinica(
    IN p_cod_cita VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarCitaClinica', 'cita_clinica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    -- Primero eliminar recetas asociadas a la cita (integridad referencial)
    DELETE FROM receta       WHERE cod_cita = p_cod_cita;
    DELETE FROM cita_clinica WHERE cod_cita = p_cod_cita;
    SELECT 'Cita clínica y recetas asociadas eliminadas correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS - cita_clinica
-- ============================================================

-- INSERT
CALL sp_InsertarCitaClinica('CIT004', '2024-05-10', 'PAC001', 'MED001', 'DIA001', 'SED001');
CALL sp_InsertarCitaClinica('CIT005', '2024-05-11', 'PAC002', 'MED001', 'DIA002', 'SED001');
CALL sp_InsertarCitaClinica('CIT006', '2024-05-12', 'PAC001', 'MED002', 'DIA003', 'SED002');
CALL sp_InsertarCitaClinica('CIT007', '2024-05-15', 'PAC003', 'MED003', 'DIA002', 'SED002');

-- VER TODOS (con JOIN a paciente, medico, especialidad, diagnostico, sede_medica)
CALL sp_ObtenerCitasClinicas();

-- VER UNO POR ID
CALL sp_ObtenerCitaClinicaPorID('CIT004');

-- ACTUALIZAR
CALL sp_ActualizarCitaClinica('CIT004', '2024-05-10', 'PAC001', 'MED001', 'DIA002', 'SED001');

-- VER EL CAMBIO
CALL sp_ObtenerCitaClinicaPorID('CIT004');

-- ELIMINAR (también elimina recetas asociadas)
CALL sp_EliminarCitaClinica('CIT004');

-- VER TODOS TRAS ELIMINAR
CALL sp_ObtenerCitasClinicas();

-- VER LOGS
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
