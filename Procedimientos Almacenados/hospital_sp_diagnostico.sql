-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: diagnostico
-- (Equivalente a CONDICION_CLINICA del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarDiagnostico$$
CREATE PROCEDURE sp_InsertarDiagnostico(
    IN p_cod_diagnostico  VARCHAR(6),
    IN p_desc_diagnostico VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_InsertarDiagnostico', 'diagnostico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    INSERT INTO diagnostico (cod_diagnostico, desc_diagnostico)
    VALUES (p_cod_diagnostico, p_desc_diagnostico);
    SELECT 'Diagnóstico insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerDiagnosticos$$
CREATE PROCEDURE sp_ObtenerDiagnosticos()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerDiagnosticos', 'diagnostico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM diagnostico;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerDiagnosticoPorID$$
CREATE PROCEDURE sp_ObtenerDiagnosticoPorID(
    IN p_cod_diagnostico VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerDiagnosticoPorID', 'diagnostico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM diagnostico WHERE cod_diagnostico = p_cod_diagnostico;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarDiagnostico$$
CREATE PROCEDURE sp_ActualizarDiagnostico(
    IN p_cod_diagnostico  VARCHAR(6),
    IN p_desc_diagnostico VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ActualizarDiagnostico', 'diagnostico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    UPDATE diagnostico
    SET desc_diagnostico = p_desc_diagnostico
    WHERE cod_diagnostico = p_cod_diagnostico;
    SELECT 'Diagnóstico actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarDiagnostico$$
CREATE PROCEDURE sp_EliminarDiagnostico(
    IN p_cod_diagnostico VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarDiagnostico', 'diagnostico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM diagnostico WHERE cod_diagnostico = p_cod_diagnostico;
    SELECT 'Diagnóstico eliminado correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS - diagnostico
-- ============================================================

-- INSERT
CALL sp_InsertarDiagnostico('DIA004', 'Gripe Fuerte');
CALL sp_InsertarDiagnostico('DIA005', 'Infección Bacteriana');
CALL sp_InsertarDiagnostico('DIA006', 'Arritmia Cardiaca');
CALL sp_InsertarDiagnostico('DIA007', 'Migraña Severa');

-- VER TODOS
CALL sp_ObtenerDiagnosticos();

-- VER UNO POR ID
CALL sp_ObtenerDiagnosticoPorID('DIA004');

-- ACTUALIZAR
CALL sp_ActualizarDiagnostico('DIA004', 'Gripe Severa');

-- VER EL CAMBIO
CALL sp_ObtenerDiagnosticoPorID('DIA004');

-- ELIMINAR
CALL sp_EliminarDiagnostico('DIA004');

-- VER TODOS TRAS ELIMINAR
CALL sp_ObtenerDiagnosticos();

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
