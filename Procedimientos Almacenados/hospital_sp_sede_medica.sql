-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: sede_medica
-- (Equivalente a CENTRO_ASISTENCIAL del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarSedeMedica$$
CREATE PROCEDURE sp_InsertarSedeMedica(
    IN p_cod_sede      VARCHAR(6),
    IN p_nom_sede      VARCHAR(100),
    IN p_ubicacion_sede VARCHAR(150)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_InsertarSedeMedica', 'sede_medica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    INSERT INTO sede_medica (cod_sede, nom_sede, ubicacion_sede)
    VALUES (p_cod_sede, p_nom_sede, p_ubicacion_sede);
    SELECT 'Sede médica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerSedesMedicas$$
CREATE PROCEDURE sp_ObtenerSedesMedicas()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerSedesMedicas', 'sede_medica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM sede_medica;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerSedeMedicaPorID$$
CREATE PROCEDURE sp_ObtenerSedeMedicaPorID(
    IN p_cod_sede VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerSedeMedicaPorID', 'sede_medica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM sede_medica WHERE cod_sede = p_cod_sede;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarSedeMedica$$
CREATE PROCEDURE sp_ActualizarSedeMedica(
    IN p_cod_sede       VARCHAR(6),
    IN p_nom_sede       VARCHAR(100),
    IN p_ubicacion_sede VARCHAR(150)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ActualizarSedeMedica', 'sede_medica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    UPDATE sede_medica
    SET nom_sede        = p_nom_sede,
        ubicacion_sede  = p_ubicacion_sede
    WHERE cod_sede = p_cod_sede;
    SELECT 'Sede médica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarSedeMedica$$
CREATE PROCEDURE sp_EliminarSedeMedica(
    IN p_cod_sede VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarSedeMedica', 'sede_medica', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM sede_medica WHERE cod_sede = p_cod_sede;
    SELECT 'Sede médica eliminada correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS - sede_medica
-- ============================================================

-- INSERT
CALL sp_InsertarSedeMedica('SED004', 'Sede Oriente', 'Carrera 20 #15-30');
CALL sp_InsertarSedeMedica('SED005', 'Sede Occidente', 'Calle 50 #8-10');

-- VER TODOS
CALL sp_ObtenerSedesMedicas();

-- VER UNO POR ID
CALL sp_ObtenerSedeMedicaPorID('SED004');

-- ACTUALIZAR
CALL sp_ActualizarSedeMedica('SED004', 'Sede Oriente', 'Carrera 22 #18-45');

-- VER EL CAMBIO
CALL sp_ObtenerSedesMedicas();

-- ELIMINAR
CALL sp_EliminarSedeMedica('SED004');

-- VER TODOS TRAS ELIMINAR
CALL sp_ObtenerSedesMedicas();

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
