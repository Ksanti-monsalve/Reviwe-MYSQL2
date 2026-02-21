-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: medicamento
-- (Equivalente a FARMACO del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarMedicamento$$
CREATE PROCEDURE sp_InsertarMedicamento(
    IN p_cod_medicamento VARCHAR(6),
    IN p_nom_medicamento VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_InsertarMedicamento', 'medicamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    INSERT INTO medicamento (cod_medicamento, nom_medicamento)
    VALUES (p_cod_medicamento, p_nom_medicamento);
    SELECT 'Medicamento insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerMedicamentos$$
CREATE PROCEDURE sp_ObtenerMedicamentos()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerMedicamentos', 'medicamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM medicamento;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerMedicamentoPorID$$
CREATE PROCEDURE sp_ObtenerMedicamentoPorID(
    IN p_cod_medicamento VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerMedicamentoPorID', 'medicamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM medicamento WHERE cod_medicamento = p_cod_medicamento;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarMedicamento$$
CREATE PROCEDURE sp_ActualizarMedicamento(
    IN p_cod_medicamento VARCHAR(6),
    IN p_nom_medicamento VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ActualizarMedicamento', 'medicamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    UPDATE medicamento
    SET nom_medicamento = p_nom_medicamento
    WHERE cod_medicamento = p_cod_medicamento;
    SELECT 'Medicamento actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarMedicamento$$
CREATE PROCEDURE sp_EliminarMedicamento(
    IN p_cod_medicamento VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarMedicamento', 'medicamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM medicamento WHERE cod_medicamento = p_cod_medicamento;
    SELECT 'Medicamento eliminado correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS - medicamento
-- ============================================================

-- INSERT
CALL sp_InsertarMedicamento('MED004', 'Paracetamol');
CALL sp_InsertarMedicamento('MED005', 'Ibuprofeno');
CALL sp_InsertarMedicamento('MED006', 'Amoxicilina');
CALL sp_InsertarMedicamento('MED007', 'Aspirina');
CALL sp_InsertarMedicamento('MED008', 'Ergotamina');

-- VER TODOS
CALL sp_ObtenerMedicamentos();

-- VER UNO POR ID
CALL sp_ObtenerMedicamentoPorID('MED004');

-- ACTUALIZAR
CALL sp_ActualizarMedicamento('MED004', 'Paracetamol 500mg');

-- VER EL CAMBIO
CALL sp_ObtenerMedicamentoPorID('MED004');

-- ELIMINAR
CALL sp_EliminarMedicamento('MED004');

-- VER TODOS TRAS ELIMINAR
CALL sp_ObtenerMedicamentos();

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
