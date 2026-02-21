-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: receta
-- (Equivalente a PRESCRIPCION_MEDICA del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarReceta$$
CREATE PROCEDURE sp_InsertarReceta(
    IN p_cod_receta      VARCHAR(6),
    IN p_cod_cita        VARCHAR(6),
    IN p_cod_medicamento VARCHAR(6),
    IN p_dosis_indicada  VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_InsertarReceta', 'receta', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    INSERT INTO receta (cod_receta, cod_cita, cod_medicamento, dosis_indicada)
    VALUES (p_cod_receta, p_cod_cita, p_cod_medicamento, p_dosis_indicada);
    SELECT 'Receta insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerRecetas$$
CREATE PROCEDURE sp_ObtenerRecetas()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerRecetas', 'receta', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT
        r.cod_receta,
        r.dosis_indicada,
        med.nom_medicamento,
        cc.cod_cita,
        cc.fec_cita,
        d.desc_diagnostico
    FROM receta r
    INNER JOIN medicamento   med ON r.cod_medicamento  = med.cod_medicamento
    INNER JOIN cita_clinica  cc  ON r.cod_cita         = cc.cod_cita
    INNER JOIN diagnostico   d   ON cc.cod_diagnostico = d.cod_diagnostico;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerRecetasPorCita$$
CREATE PROCEDURE sp_ObtenerRecetasPorCita(
    IN p_cod_cita VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerRecetasPorCita', 'receta', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT
        r.cod_receta,
        med.nom_medicamento,
        r.dosis_indicada
    FROM receta r
    INNER JOIN medicamento med ON r.cod_medicamento = med.cod_medicamento
    WHERE r.cod_cita = p_cod_cita;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarReceta$$
CREATE PROCEDURE sp_ActualizarReceta(
    IN p_cod_receta      VARCHAR(6),
    IN p_cod_medicamento VARCHAR(6),
    IN p_dosis_indicada  VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ActualizarReceta', 'receta', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    UPDATE receta
    SET cod_medicamento = p_cod_medicamento,
        dosis_indicada  = p_dosis_indicada
    WHERE cod_receta = p_cod_receta;
    SELECT 'Receta actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarReceta$$
CREATE PROCEDURE sp_EliminarReceta(
    IN p_cod_receta VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarReceta', 'receta', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM receta WHERE cod_receta = p_cod_receta;
    SELECT 'Receta eliminada correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS - receta
-- ============================================================

-- INSERT
CALL sp_InsertarReceta('REC004', 'CIT001', 'MED001', '500mg cada 8 horas');
CALL sp_InsertarReceta('REC005', 'CIT001', 'MED002', '400mg después de comidas');
CALL sp_InsertarReceta('REC006', 'CIT002', 'MED003', '875mg cada 12 horas');
CALL sp_InsertarReceta('REC007', 'CIT003', 'MED001', '100mg en ayunas');
CALL sp_InsertarReceta('REC008', 'CIT003', 'MED002', '1mg antes de dormir');

-- VER TODOS (con JOIN a cita_clinica, medicamento y diagnostico)
CALL sp_ObtenerRecetas();

-- VER RECETAS DE UNA CITA ESPECÍFICA
CALL sp_ObtenerRecetasPorCita('CIT001');

-- ACTUALIZAR DOSIS
CALL sp_ActualizarReceta('REC004', 'MED001', '1000mg cada 8 horas');

-- VER EL CAMBIO
CALL sp_ObtenerRecetasPorCita('CIT001');

-- ELIMINAR
CALL sp_EliminarReceta('REC004');

-- VER TODOS TRAS ELIMINAR
CALL sp_ObtenerRecetas();

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
