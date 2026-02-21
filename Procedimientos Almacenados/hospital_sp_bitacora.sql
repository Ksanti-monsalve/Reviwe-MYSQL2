-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: bitacora_errores
-- (Equivalente a LOGS_ERRORES del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerBitacora$$
CREATE PROCEDURE sp_ObtenerBitacora()
BEGIN
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
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerBitacoraPorTabla$$
CREATE PROCEDURE sp_ObtenerBitacoraPorTabla(
    IN p_nom_tabla VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerBitacoraPorTabla', 'bitacora_errores', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

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
    WHERE nom_tabla = p_nom_tabla
    ORDER BY fecha_hora DESC;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerBitacoraPorFecha$$
CREATE PROCEDURE sp_ObtenerBitacoraPorFecha(
    IN p_fecha_inicio DATETIME,
    IN p_fecha_fin    DATETIME
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerBitacoraPorFecha', 'bitacora_errores', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

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
    WHERE fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY fecha_hora DESC;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarBitacora$$
CREATE PROCEDURE sp_EliminarBitacora()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarBitacora', 'bitacora_errores', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM bitacora_errores;
    SELECT 'Todos los registros de bitácora eliminados correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarBitacoraPorID$$
CREATE PROCEDURE sp_EliminarBitacoraPorID(
    IN p_log_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarBitacoraPorID', 'bitacora_errores', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM bitacora_errores WHERE log_id = p_log_id;
    SELECT 'Registro de bitácora eliminado correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR TODOS LOS SPs Y FUNCIONES CREADOS
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';
SHOW FUNCTION  STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS DE ELIMINACIÓN (adaptadas a nombres nuevos)
-- ============================================================

-- ELIMINAR UNA RECETA ESPECÍFICA
CALL sp_EliminarReceta('REC005');
CALL sp_ObtenerRecetasPorCita('CIT001');

-- ELIMINAR UNA CITA COMPLETA (borra sus recetas automáticamente)
CALL sp_EliminarCitaClinica('CIT007');
CALL sp_ObtenerCitasClinicas();

-- ELIMINAR UN MÉDICO
CALL sp_EliminarMedico('MED006');
CALL sp_ObtenerMedicos();

-- ELIMINAR UN PACIENTE
CALL sp_EliminarPaciente('PAC006');
CALL sp_ObtenerPacientes();

-- ELIMINAR UNA SEDE MÉDICA
CALL sp_EliminarSedeMedica('SED005');
CALL sp_ObtenerSedesMedicas();

-- ELIMINAR UN DEPARTAMENTO
CALL sp_EliminarDepartamento('DEP005');
CALL sp_ObtenerDepartamentos();

-- ELIMINAR UNA ESPECIALIDAD
CALL sp_EliminarEspecialidad('ESP006');
CALL sp_ObtenerEspecialidades();

-- ELIMINAR UN DIAGNÓSTICO
CALL sp_EliminarDiagnostico('DIA007');
CALL sp_ObtenerDiagnosticos();

-- ELIMINAR UN MEDICAMENTO
CALL sp_EliminarMedicamento('MED008');
CALL sp_ObtenerMedicamentos();

-- ============================================================
-- PRUEBA DE BITÁCORA (errores registrados automáticamente)
-- ============================================================

-- Provocar error a propósito (ID duplicado)
CALL sp_InsertarDepartamento('DEP001', 'Duplicado', 'Dr. Prueba');

-- Provocar otro error (FK inexistente)
CALL sp_InsertarMedico('MED099', 'Dr. Prueba', 'ESP099', 'DEP099');

-- VER TODOS LOS REGISTROS DE BITÁCORA
CALL sp_ObtenerBitacora();

-- VER BITÁCORA POR TABLA ESPECÍFICA
CALL sp_ObtenerBitacoraPorTabla('departamento');

-- VER BITÁCORA POR RANGO DE FECHA
CALL sp_ObtenerBitacoraPorFecha('2024-01-01 00:00:00', '2026-12-31 23:59:59');

-- ELIMINAR UN REGISTRO ESPECÍFICO DE BITÁCORA
CALL sp_EliminarBitacoraPorID(1);

-- ELIMINAR TODOS LOS REGISTROS DE BITÁCORA
CALL sp_EliminarBitacora();

-- VERIFICAR QUE SE LIMPIARON
CALL sp_ObtenerBitacora();
