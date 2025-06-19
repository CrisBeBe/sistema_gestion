/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `bpm_web` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bpm_web`;

CREATE TABLE IF NOT EXISTS `asignacionestareas` (
  `id_asignacion` int NOT NULL AUTO_INCREMENT,
  `tarea_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `rol_asignacion` enum('responsable','colaborador','revisor') COLLATE utf8mb4_unicode_ci DEFAULT 'responsable',
  `fecha_asignacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` enum('activa','inactiva') COLLATE utf8mb4_unicode_ci DEFAULT 'activa',
  PRIMARY KEY (`id_asignacion`),
  UNIQUE KEY `tarea_id` (`tarea_id`,`usuario_id`,`rol_asignacion`),
  KEY `idx_asignaciones_usuario` (`usuario_id`),
  CONSTRAINT `asignacionestareas_ibfk_1` FOREIGN KEY (`tarea_id`) REFERENCES `tareas` (`id_tarea`) ON DELETE CASCADE,
  CONSTRAINT `asignacionestareas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `auditoria` (
  `id_auditoria` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `modulo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entidad_afectada` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_entidad_afectada` int DEFAULT NULL,
  `accion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `detalles` text COLLATE utf8mb4_unicode_ci,
  `ip_origen` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_auditoria_usuario` (`id_usuario`),
  KEY `idx_auditoria_fecha` (`fecha`),
  CONSTRAINT `auditoria_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `auditoria` (`id_auditoria`, `id_usuario`, `modulo`, `entidad_afectada`, `id_entidad_afectada`, `accion`, `detalles`, `ip_origen`, `user_agent`, `fecha`) VALUES
	(1, NULL, 'Usuarios', 'usuarios', 3, 'crear', 'Nuevo usuario creado: crisbebe', NULL, NULL, '2025-06-14 04:39:51'),
	(2, NULL, 'Usuarios', 'usuarios', 4, 'crear', 'Nuevo usuario creado: DannerDQ', NULL, NULL, '2025-06-14 05:27:41');

CREATE TABLE IF NOT EXISTS `categoriasprocesos` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `icono` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `comentarios` (
  `id_comentario` bigint NOT NULL AUTO_INCREMENT,
  `proceso_id` int DEFAULT NULL,
  `tarea_id` int DEFAULT NULL,
  `usuario_id` int NOT NULL,
  `contenido` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `editado` tinyint(1) DEFAULT '0',
  `fecha_edicion` datetime DEFAULT NULL,
  PRIMARY KEY (`id_comentario`),
  KEY `proceso_id` (`proceso_id`),
  KEY `tarea_id` (`tarea_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `comentarios_ibfk_1` FOREIGN KEY (`proceso_id`) REFERENCES `procesos` (`id_proceso`) ON DELETE CASCADE,
  CONSTRAINT `comentarios_ibfk_2` FOREIGN KEY (`tarea_id`) REFERENCES `tareas` (`id_tarea`) ON DELETE CASCADE,
  CONSTRAINT `comentarios_ibfk_3` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `configuraciones` (
  `id_configuracion` int NOT NULL AUTO_INCREMENT,
  `clave` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` text COLLATE utf8mb4_unicode_ci,
  `tipo` enum('string','number','boolean','json') COLLATE utf8mb4_unicode_ci DEFAULT 'string',
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `editable` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_configuracion`),
  UNIQUE KEY `clave` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `departamentos` (
  `id_departamento` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `responsable_id` int DEFAULT NULL,
  `estado` enum('activo','inactivo') COLLATE utf8mb4_unicode_ci DEFAULT 'activo',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_departamento`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `departamentos` (`id_departamento`, `nombre`, `descripcion`, `responsable_id`, `estado`, `fecha_creacion`) VALUES
	(1, 'ceo', 'ceo de el sistema', 1, 'activo', '2025-05-29 19:21:08');

CREATE TABLE IF NOT EXISTS `documentos` (
  `id_documento` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `tipo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tamano` bigint DEFAULT NULL,
  `ruta_almacenamiento` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `hash_archivo` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subido_por` int NOT NULL,
  `fecha_subida` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_documento`),
  KEY `subido_por` (`subido_por`),
  CONSTRAINT `documentos_ibfk_1` FOREIGN KEY (`subido_por`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `eventosautomatizados` (
  `id_evento` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `tipo_evento` enum('inicio_proceso','tarea_completada','proceso_finalizado','fecha_limite','personalizado') COLLATE utf8mb4_unicode_ci NOT NULL,
  `expresion_trigger` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `accion_ejecutar` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `parametros_accion` text COLLATE utf8mb4_unicode_ci,
  `creado_por` int NOT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `estado` enum('activo','inactivo','pausado') COLLATE utf8mb4_unicode_ci DEFAULT 'activo',
  PRIMARY KEY (`id_evento`),
  KEY `creado_por` (`creado_por`),
  CONSTRAINT `eventosautomatizados_ibfk_1` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `flujoprocesos` (
  `id_flujo` int NOT NULL AUTO_INCREMENT,
  `proceso_id` int NOT NULL,
  `tarea_origen_id` int NOT NULL,
  `tarea_destino_id` int NOT NULL,
  `condiciones` text COLLATE utf8mb4_unicode_ci,
  `tipo_transicion` enum('automatica','manual','condicional') COLLATE utf8mb4_unicode_ci DEFAULT 'automatica',
  PRIMARY KEY (`id_flujo`),
  KEY `proceso_id` (`proceso_id`),
  KEY `tarea_origen_id` (`tarea_origen_id`),
  KEY `tarea_destino_id` (`tarea_destino_id`),
  CONSTRAINT `flujoprocesos_ibfk_1` FOREIGN KEY (`proceso_id`) REFERENCES `procesos` (`id_proceso`) ON DELETE CASCADE,
  CONSTRAINT `flujoprocesos_ibfk_2` FOREIGN KEY (`tarea_origen_id`) REFERENCES `tareas` (`id_tarea`) ON DELETE CASCADE,
  CONSTRAINT `flujoprocesos_ibfk_3` FOREIGN KEY (`tarea_destino_id`) REFERENCES `tareas` (`id_tarea`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `metricas` (
  `id_metrica` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `tipo_metrica` enum('tiempo','cantidad','porcentaje','calidad') COLLATE utf8mb4_unicode_ci NOT NULL,
  `unidad` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_metrica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `notificaciones` (
  `id_notificacion` bigint NOT NULL AUTO_INCREMENT,
  `usuario_destino_id` int NOT NULL,
  `titulo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` enum('tarea','proceso','sistema','mensaje') COLLATE utf8mb4_unicode_ci NOT NULL,
  `entidad_relacionada` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_entidad_relacionada` int DEFAULT NULL,
  `leida` tinyint(1) DEFAULT '0',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_lectura` datetime DEFAULT NULL,
  PRIMARY KEY (`id_notificacion`),
  KEY `idx_notificaciones_usuario` (`usuario_destino_id`),
  KEY `idx_notificaciones_leida` (`leida`),
  CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`usuario_destino_id`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DELIMITER //
CREATE PROCEDURE `PA_actualizar_categoria`(
    IN p_id_categoria INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_icono VARCHAR(50)
)
BEGIN
    DECLARE old_nombre VARCHAR(100);
    DECLARE old_descripcion TEXT;
    DECLARE old_icono VARCHAR(50);
    
    SELECT nombre, descripcion, icono 
    INTO old_nombre, old_descripcion, old_icono
    FROM categoriasprocesos WHERE id_categoria = p_id_categoria;
    
    UPDATE categoriasprocesos 
    SET nombre = p_nombre, 
        descripcion = p_descripcion, 
        icono = p_icono
    WHERE id_categoria = p_id_categoria;
    
    -- Registrar cambios en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Categorías', 'categoriasprocesos', p_id_categoria, 'actualizar', 
            CONCAT('Cambios: Nombre(', old_nombre, '->', p_nombre, '), ',
                   'Descripción(', IFNULL(old_descripcion, 'NULL'), '->', IFNULL(p_descripcion, 'NULL'), '), ',
                   'Icono(', IFNULL(old_icono, 'NULL'), '->', IFNULL(p_icono, 'NULL'), ')'));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_actualizar_configuracion`(
    IN p_clave VARCHAR(100),
    IN p_valor TEXT,
    IN p_usuario_id INT
)
BEGIN
    DECLARE old_valor TEXT;
    DECLARE v_id INT;
    
    SELECT valor, id_configuracion INTO old_valor, v_id
    FROM configuraciones WHERE clave = p_clave;
    
    UPDATE configuraciones 
    SET valor = p_valor,
        fecha_actualizacion = NOW()
    WHERE clave = p_clave;
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_id, 'Configuraciones', 'configuraciones', v_id, 'actualizar', 
            CONCAT('Configuración ', p_clave, ' actualizada de ', IFNULL(old_valor, 'NULL'), ' a ', IFNULL(p_valor, 'NULL')));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_actualizar_departamento`(
    IN p_id_departamento INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_responsable_id INT,
    IN p_estado ENUM('activo','inactivo')
)
BEGIN
    DECLARE old_nombre VARCHAR(100);
    DECLARE old_descripcion TEXT;
    DECLARE old_responsable INT;
    DECLARE old_estado VARCHAR(20);
    
    SELECT nombre, descripcion, responsable_id, estado 
    INTO old_nombre, old_descripcion, old_responsable, old_estado
    FROM departamentos WHERE id_departamento = p_id_departamento;
    
    UPDATE departamentos 
    SET nombre = p_nombre, 
        descripcion = p_descripcion, 
        responsable_id = p_responsable_id,
        estado = p_estado
    WHERE id_departamento = p_id_departamento;
    
    -- Registrar cambios en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Departamentos', 'departamentos', p_id_departamento, 'actualizar', 
            CONCAT('Cambios: Nombre(', old_nombre, '->', p_nombre, '), ',
                   'Descripción(', IFNULL(old_descripcion, 'NULL'), '->', IFNULL(p_descripcion, 'NULL'), '), ',
                   'Responsable(', IFNULL(old_responsable, 'NULL'), '->', IFNULL(p_responsable_id, 'NULL'), '), ',
                   'Estado(', old_estado, '->', p_estado, ')'));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_actualizar_evento_automatizado`(
    IN p_id_evento INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_tipo_evento ENUM('inicio_proceso','tarea_completada','proceso_finalizado','fecha_limite','personalizado'),
    IN p_expresion_trigger TEXT,
    IN p_accion_ejecutar TEXT,
    IN p_parametros_accion TEXT,
    IN p_estado ENUM('activo','inactivo','pausado'),
    IN p_usuario_id INT
)
BEGIN
    DECLARE old_nombre VARCHAR(100);
    DECLARE old_tipo VARCHAR(50);
    DECLARE old_estado VARCHAR(20);
    
    SELECT nombre, tipo_evento, estado 
    INTO old_nombre, old_tipo, old_estado
    FROM eventosautomatizados WHERE id_evento = p_id_evento;
    
    UPDATE eventosautomatizados 
    SET nombre = p_nombre, 
        descripcion = p_descripcion, 
        tipo_evento = p_tipo_evento,
        expresion_trigger = p_expresion_trigger,
        accion_ejecutar = p_accion_ejecutar,
        parametros_accion = p_parametros_accion,
        estado = p_estado,
        fecha_actualizacion = NOW()
    WHERE id_evento = p_id_evento;
    
    -- Registrar cambios en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_id, 'Eventos', 'eventosautomatizados', p_id_evento, 'actualizar', 
            CONCAT('Cambios: Nombre(', old_nombre, '->', p_nombre, '), ',
                   'Tipo(', old_tipo, '->', p_tipo_evento, '), ',
                   'Estado(', old_estado, '->', p_estado, ')'));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_actualizar_plantilla_proceso`(
    IN p_id_plantilla INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_categoria_id INT,
    IN p_contenido LONGTEXT,
    IN p_publico TINYINT(1),
    IN p_usuario_id INT
)
BEGIN
    DECLARE old_nombre VARCHAR(100);
    DECLARE old_descripcion TEXT;
    DECLARE old_categoria INT;
    DECLARE old_publico TINYINT(1);
    
    SELECT nombre, descripcion, categoria_id, publico 
    INTO old_nombre, old_descripcion, old_categoria, old_publico
    FROM plantillasprocesos WHERE id_plantilla = p_id_plantilla;
    
    UPDATE plantillasprocesos 
    SET nombre = p_nombre, 
        descripcion = p_descripcion, 
        categoria_id = p_categoria_id,
        contenido = p_contenido,
        publico = p_publico,
        fecha_actualizacion = NOW()
    WHERE id_plantilla = p_id_plantilla;
    
    -- Registrar cambios en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_id, 'Plantillas', 'plantillasprocesos', p_id_plantilla, 'actualizar', 
            CONCAT('Cambios: Nombre(', old_nombre, '->', p_nombre, '), ',
                   'Descripción(', IFNULL(old_descripcion, 'NULL'), '->', IFNULL(p_descripcion, 'NULL'), '), ',
                   'Categoría(', IFNULL(old_categoria, 'NULL'), '->', IFNULL(p_categoria_id, 'NULL'), '), ',
                   'Público(', old_publico, '->', p_publico, ')'));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_actualizar_proceso`(
    IN p_id_proceso INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_categoria_id INT,
    IN p_responsable_id INT,
    IN p_estado ENUM('borrador','activo','en revision','finalizado','archivado'),
    IN p_version VARCHAR(20),
    IN p_fecha_inicio DATETIME,
    IN p_fecha_fin DATETIME,
    IN p_usuario_actualizacion INT
)
BEGIN
    DECLARE old_nombre VARCHAR(100);
    DECLARE old_descripcion TEXT;
    DECLARE old_categoria INT;
    DECLARE old_responsable INT;
    DECLARE old_estado VARCHAR(20);
    DECLARE old_version VARCHAR(20);
    DECLARE old_fecha_inicio DATETIME;
    DECLARE old_fecha_fin DATETIME;
    
    SELECT nombre, descripcion, categoria_id, responsable_id, estado, version, fecha_inicio, fecha_fin
    INTO old_nombre, old_descripcion, old_categoria, old_responsable, old_estado, old_version, old_fecha_inicio, old_fecha_fin
    FROM procesos WHERE id_proceso = p_id_proceso;
    
    UPDATE procesos 
    SET nombre = p_nombre, 
        descripcion = p_descripcion, 
        categoria_id = p_categoria_id,
        responsable_id = p_responsable_id,
        estado = p_estado,
        version = p_version,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin,
        fecha_actualizacion = NOW()
    WHERE id_proceso = p_id_proceso;
    
    -- Registrar cambios en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_actualizacion, 'Procesos', 'procesos', p_id_proceso, 'actualizar', 
            CONCAT('Cambios: Nombre(', old_nombre, '->', p_nombre, '), ',
                   'Descripción(', IFNULL(old_descripcion, 'NULL'), '->', IFNULL(p_descripcion, 'NULL'), '), ',
                   'Categoría(', IFNULL(old_categoria, 'NULL'), '->', IFNULL(p_categoria_id, 'NULL'), '), ',
                   'Responsable(', old_responsable, '->', p_responsable_id, '), ',
                   'Estado(', old_estado, '->', p_estado, '), ',
                   'Versión(', old_version, '->', p_version, '), ',
                   'Fecha inicio(', IFNULL(old_fecha_inicio, 'NULL'), '->', IFNULL(p_fecha_inicio, 'NULL'), '), ',
                   'Fecha fin(', IFNULL(old_fecha_fin, 'NULL'), '->', IFNULL(p_fecha_fin, 'NULL'), ')'));
    
    -- Si el proceso se marca como finalizado, completar todas sus tareas pendientes
    IF p_estado = 'finalizado' THEN
        UPDATE tareas 
        SET estado = 'completada',
            fecha_fin = NOW()
        WHERE id_proceso = p_id_proceso AND estado NOT IN ('completada', 'cancelada');
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_actualizar_rol`(
    IN p_id_rol INT,
    IN p_nombre VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_nivel_permisos INT
)
BEGIN
    DECLARE old_nombre VARCHAR(50);
    DECLARE old_descripcion TEXT;
    DECLARE old_nivel INT;
    
    SELECT nombre, descripcion, nivel_permisos 
    INTO old_nombre, old_descripcion, old_nivel
    FROM roles WHERE id_rol = p_id_rol;
    
    UPDATE roles 
    SET nombre = p_nombre, 
        descripcion = p_descripcion, 
        nivel_permisos = p_nivel_permisos
    WHERE id_rol = p_id_rol;
    
    -- Registrar cambios en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Roles', 'roles', p_id_rol, 'actualizar', 
            CONCAT('Cambios: Nombre(', old_nombre, '->', p_nombre, '), ',
                   'Descripción(', IFNULL(old_descripcion, 'NULL'), '->', IFNULL(p_descripcion, 'NULL'), '), ',
                   'Nivel permisos(', old_nivel, '->', p_nivel_permisos, ')'));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_actualizar_tareas`(
    IN p_id_tarea INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_estado ENUM('pendiente','en progreso','completada','rechazada','cancelada'),
    IN p_prioridad ENUM('baja','media','alta'),
    IN p_fecha_limite DATETIME
)
BEGIN
    UPDATE tareas
    SET 
        nombre = p_nombre,
        descripcion = p_descripcion,
        estado = p_estado,
        prioridad = p_prioridad,
        fecha_limite = p_fecha_limite
    WHERE id_tarea = p_id_tarea;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_actualizar_usuario`(
    IN p_id_usuario INT,
    IN p_nombre VARCHAR(100),
    IN p_correo VARCHAR(100),
    IN p_rol_id INT,
    IN p_departamento_id INT,
    IN p_estado ENUM('activo','inactivo','suspendido')
)
BEGIN
    DECLARE old_nombre VARCHAR(100);
    DECLARE old_correo VARCHAR(100);
    DECLARE old_rol_id INT;
    DECLARE old_departamento_id INT;
    DECLARE old_estado VARCHAR(20);
    
    SELECT nombre, correo, rol_id, departamento_id, estado 
    INTO old_nombre, old_correo, old_rol_id, old_departamento_id, old_estado
    FROM usuarios WHERE id_usuario = p_id_usuario;
    
    UPDATE usuarios 
    SET nombre = p_nombre, 
        correo = p_correo, 
        rol_id = p_rol_id, 
        departamento_id = p_departamento_id,
        estado = p_estado
    WHERE id_usuario = p_id_usuario;
    
    -- Registrar cambios en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Usuarios', 'usuarios', p_id_usuario, 'actualizar', 
            CONCAT('Cambios: Nombre(', old_nombre, '->', p_nombre, '), ',
                   'Correo(', old_correo, '->', p_correo, '), ',
                   'Rol(', old_rol_id, '->', p_rol_id, '), ',
                   'Departamento(', IFNULL(old_departamento_id, 'NULL'), '->', IFNULL(p_departamento_id, 'NULL'), '), ',
                   'Estado(', old_estado, '->', p_estado, ')'));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_asignar_tarea`(
    IN p_tarea_id INT,
    IN p_usuario_id INT,
    IN p_rol_asignacion ENUM('responsable','colaborador','revisor'),
    IN p_usuario_asignador INT
)
BEGIN
    DECLARE v_existe INT;
    DECLARE v_tarea_nombre VARCHAR(100);
    DECLARE v_usuario_nombre VARCHAR(100);
    
    -- Verificar si la asignación ya existe
    SELECT COUNT(*) INTO v_existe
    FROM asignacionestareas
    WHERE tarea_id = p_tarea_id AND usuario_id = p_usuario_id AND rol_asignacion = p_rol_asignacion;
    
    -- Obtener nombres para auditoría
    SELECT nombre INTO v_tarea_nombre FROM tareas WHERE id_tarea = p_tarea_id;
    SELECT nombre INTO v_usuario_nombre FROM usuarios WHERE id_usuario = p_usuario_id;
    
    IF v_existe = 0 THEN
        INSERT INTO asignacionestareas (tarea_id, usuario_id, rol_asignacion)
        VALUES (p_tarea_id, p_usuario_id, p_rol_asignacion);
        
        -- Registrar en auditoría
        INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
        VALUES (p_usuario_asignador, 'Asignaciones', 'asignacionestareas', LAST_INSERT_ID(), 'asignar', 
                CONCAT('Usuario ', v_usuario_nombre, ' asignado como ', p_rol_asignacion, ' a la tarea: ', v_tarea_nombre));
        
        -- Crear notificación para el usuario asignado
        INSERT INTO notificaciones (usuario_destino_id, titulo, mensaje, tipo, entidad_relacionada, id_entidad_relacionada)
        VALUES (p_usuario_id, 'Nueva asignación', 
                CONCAT('Has sido asignado como ', p_rol_asignacion, ' a la tarea "', v_tarea_nombre, '"'), 
                'tarea', 'tareas', p_tarea_id);
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_asociar_documento_proceso`(
    IN p_proceso_id INT,
    IN p_documento_id INT,
    IN p_tipo_relacion ENUM('plantilla','entrada','salida','referencia'),
    IN p_obligatorio TINYINT(1),
    IN p_usuario_id INT
)
BEGIN
    DECLARE v_proceso_nombre VARCHAR(100);
    DECLARE v_documento_nombre VARCHAR(255);
    
    -- Obtener nombres para auditoría
    SELECT nombre INTO v_proceso_nombre FROM procesos WHERE id_proceso = p_proceso_id;
    SELECT nombre INTO v_documento_nombre FROM documentos WHERE id_documento = p_documento_id;
    
    INSERT INTO procesosdocumentos (proceso_id, documento_id, tipo_relacion, obligatorio)
    VALUES (p_proceso_id, p_documento_id, p_tipo_relacion, p_obligatorio);
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_id, 'Documentos', 'procesosdocumentos', LAST_INSERT_ID(), 'asociar', 
            CONCAT('Documento ', v_documento_nombre, ' asociado como ', p_tipo_relacion, 
                   ' al proceso: ', v_proceso_nombre));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_autenticar_usuario`(
    IN p_correo VARCHAR(100),
    IN p_contrasena TEXT,
    OUT p_id_usuario INT,
    OUT p_nombre VARCHAR(100),
    OUT p_rol_id INT,
    OUT p_estado VARCHAR(20)
)
BEGIN
    DECLARE v_hash TEXT;
    DECLARE v_salt VARCHAR(50);
    
    SELECT id_usuario, nombre, rol_id, estado, contraseña_hash, salt 
    INTO p_id_usuario, p_nombre, p_rol_id, p_estado, v_hash, v_salt
    FROM usuarios 
    WHERE correo = p_correo;
    
    IF v_hash IS NULL OR v_hash != SHA2(CONCAT(p_contrasena, v_salt), 256) THEN
        SET p_id_usuario = NULL;
        SET p_nombre = NULL;
        SET p_rol_id = NULL;
        SET p_estado = NULL;
    END IF;
    
    -- Actualizar último acceso si la autenticación fue exitosa
    IF p_id_usuario IS NOT NULL THEN
        UPDATE usuarios SET ultimo_acceso = NOW() WHERE id_usuario = p_id_usuario;
        
        -- Registrar en auditoría
        INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
        VALUES (p_id_usuario, 'Autenticación', 'usuarios', p_id_usuario, 'inicio_sesion', 'Inicio de sesión exitoso');
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_cambiar_contrasena`(
    IN p_id_usuario INT,
    IN p_nueva_contrasena TEXT
)
BEGIN
    DECLARE v_salt VARCHAR(50);
    
    SELECT salt INTO v_salt FROM usuarios WHERE id_usuario = p_id_usuario;
    
    UPDATE usuarios 
    SET contraseña_hash = SHA2(CONCAT(p_nueva_contrasena, v_salt), 256)
    WHERE id_usuario = p_id_usuario;
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Usuarios', 'usuarios', p_id_usuario, 'cambiar_contraseña', 'Contraseña actualizada');
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_cambiar_estado_proceso`(
    IN p_id_proceso INT,
    IN p_nuevo_estado ENUM('borrador','activo','en revision','finalizado','archivado'),
    IN p_usuario_id INT
)
BEGIN
    DECLARE old_estado VARCHAR(20);
    DECLARE v_nombre VARCHAR(100);
    
    SELECT estado, nombre INTO old_estado, v_nombre 
    FROM procesos WHERE id_proceso = p_id_proceso;
    
    UPDATE procesos 
    SET estado = p_nuevo_estado,
        fecha_actualizacion = NOW()
    WHERE id_proceso = p_id_proceso;
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_id, 'Procesos', 'procesos', p_id_proceso, 'cambiar_estado', 
            CONCAT('Estado cambiado de ', old_estado, ' a ', p_nuevo_estado, ' para el proceso: ', v_nombre));
    
    -- Si el proceso se marca como finalizado, completar todas sus tareas pendientes
    IF p_nuevo_estado = 'finalizado' THEN
        UPDATE tareas 
        SET estado = 'completada',
            fecha_fin = NOW()
        WHERE id_proceso = p_id_proceso AND estado NOT IN ('completada', 'cancelada');
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_contar_notificaciones_no_leidas`(
    IN p_usuario_id INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM notificaciones
    WHERE usuario_destino_id = p_usuario_id AND leida = 0;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_categoria`(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_icono VARCHAR(50),
    OUT p_id_categoria INT
)
BEGIN
    INSERT INTO categoriasprocesos (nombre, descripcion, icono)
    VALUES (p_nombre, p_descripcion, p_icono);
    
    SET p_id_categoria = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Categorías', 'categoriasprocesos', p_id_categoria, 'crear', CONCAT('Nueva categoría creada: ', p_nombre));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_comentario`(
    IN p_proceso_id INT,
    IN p_tarea_id INT,
    IN p_usuario_id INT,
    IN p_contenido TEXT,
    OUT p_id_comentario BIGINT
)
BEGIN
    INSERT INTO comentarios (proceso_id, tarea_id, usuario_id, contenido)
    VALUES (p_proceso_id, p_tarea_id, p_usuario_id, p_contenido);
    
    SET p_id_comentario = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_id, 'Comentarios', 'comentarios', p_id_comentario, 'crear', 
            CONCAT('Nuevo comentario creado por usuario ID: ', p_usuario_id));
    
    -- Crear notificaciones para usuarios relevantes
    IF p_tarea_id IS NOT NULL THEN
        -- Notificar a los asignados a la tarea
        INSERT INTO notificaciones (usuario_destino_id, titulo, mensaje, tipo, entidad_relacionada, id_entidad_relacionada)
        SELECT a.usuario_id, 
               'Nuevo comentario en tarea', 
               CONCAT('Hay un nuevo comentario en una tarea asignada a ti'), 
               'tarea', 
               'tareas', 
               p_tarea_id
        FROM asignacionestareas a
        WHERE a.tarea_id = p_tarea_id AND a.usuario_id != p_usuario_id;
    ELSE
        -- Notificar a los responsables del proceso
        INSERT INTO notificaciones (usuario_destino_id, titulo, mensaje, tipo, entidad_relacionada, id_entidad_relacionada)
        SELECT p.responsable_id, 
               'Nuevo comentario en proceso', 
               CONCAT('Hay un nuevo comentario en el proceso "', p.nombre, '"'), 
               'proceso', 
               'procesos', 
               p_proceso_id
        FROM procesos p
        WHERE p.id_proceso = p_proceso_id AND p.responsable_id != p_usuario_id;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_departamento`(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_responsable_id INT,
    OUT p_id_departamento INT
)
BEGIN
    INSERT INTO departamentos (nombre, descripcion, responsable_id)
    VALUES (p_nombre, p_descripcion, p_responsable_id);
    
    SET p_id_departamento = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Departamentos', 'departamentos', p_id_departamento, 'crear', CONCAT('Nuevo departamento creado: ', p_nombre));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_documento`(
    IN p_nombre VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_tipo VARCHAR(50),
    IN p_tamano BIGINT,
    IN p_ruta_almacenamiento TEXT,
    IN p_hash_archivo VARCHAR(64),
    IN p_subido_por INT,
    OUT p_id_documento INT
)
BEGIN
    INSERT INTO documentos (nombre, descripcion, tipo, tamano, ruta_almacenamiento, hash_archivo, subido_por)
    VALUES (p_nombre, p_descripcion, p_tipo, p_tamano, p_ruta_almacenamiento, p_hash_archivo, p_subido_por);
    
    SET p_id_documento = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_subido_por, 'Documentos', 'documentos', p_id_documento, 'subir', 
            CONCAT('Nuevo documento subido: ', p_nombre, ' (', p_tipo, ')'));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_evento_automatizado`(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_tipo_evento ENUM('inicio_proceso','tarea_completada','proceso_finalizado','fecha_limite','personalizado'),
    IN p_expresion_trigger TEXT,
    IN p_accion_ejecutar TEXT,
    IN p_parametros_accion TEXT,
    IN p_creado_por INT,
    IN p_estado ENUM('activo','inactivo','pausado'),
    OUT p_id_evento INT
)
BEGIN
    INSERT INTO eventosautomatizados (nombre, descripcion, tipo_evento, expresion_trigger, accion_ejecutar, parametros_accion, creado_por, estado)
    VALUES (p_nombre, p_descripcion, p_tipo_evento, p_expresion_trigger, p_accion_ejecutar, p_parametros_accion, p_creado_por, p_estado);
    
    SET p_id_evento = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_creado_por, 'Eventos', 'eventosautomatizados', p_id_evento, 'crear', 
            CONCAT('Nuevo evento automatizado creado: ', p_nombre, ' (Tipo: ', p_tipo_evento, ')'));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_metrica`(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_tipo_metrica ENUM('tiempo','cantidad','porcentaje','calidad'),
    IN p_unidad VARCHAR(20),
    OUT p_id_metrica INT
)
BEGIN
    INSERT INTO metricas (nombre, descripcion, tipo_metrica, unidad)
    VALUES (p_nombre, p_descripcion, p_tipo_metrica, p_unidad);
    
    SET p_id_metrica = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Métricas', 'metricas', p_id_metrica, 'crear', 
            CONCAT('Nueva métrica creada: ', p_nombre, ' (Tipo: ', p_tipo_metrica, ')'));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_plantilla_proceso`(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_categoria_id INT,
    IN p_contenido LONGTEXT,
    IN p_creado_por INT,
    IN p_publico TINYINT(1),
    OUT p_id_plantilla INT
)
BEGIN
    INSERT INTO plantillasprocesos (nombre, descripcion, categoria_id, contenido, creado_por, publico)
    VALUES (p_nombre, p_descripcion, p_categoria_id, p_contenido, p_creado_por, p_publico);
    
    SET p_id_plantilla = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_creado_por, 'Plantillas', 'plantillasprocesos', p_id_plantilla, 'crear', 
            CONCAT('Nueva plantilla creada: ', p_nombre));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_proceso`(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_categoria_id INT,
    IN p_creado_por INT,
    IN p_responsable_id INT,
    IN p_estado ENUM('borrador','activo','en revision','finalizado','archivado'),
    IN p_version VARCHAR(20),
    OUT p_id_proceso INT
)
BEGIN
    INSERT INTO procesos (nombre, descripcion, categoria_id, creado_por, responsable_id, estado, version)
    VALUES (p_nombre, p_descripcion, p_categoria_id, p_creado_por, p_responsable_id, p_estado, p_version);
    
    SET p_id_proceso = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_creado_por, 'Procesos', 'procesos', p_id_proceso, 'crear', CONCAT('Nuevo proceso creado: ', p_nombre));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_rol`(
    IN p_nombre VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_nivel_permisos INT,
    OUT p_id_rol INT
)
BEGIN
    INSERT INTO roles (nombre, descripcion, nivel_permisos)
    VALUES (p_nombre, p_descripcion, p_nivel_permisos);
    
    SET p_id_rol = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Roles', 'roles', p_id_rol, 'crear', CONCAT('Nuevo rol creado: ', p_nombre));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_tarea`(
    IN p_id_proceso INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_orden_ejecucion INT,
    IN p_tipo_tarea ENUM('manual','automatica','aprobacion'),
    IN p_prioridad ENUM('baja','media','alta','critica'),
    IN p_fecha_limite DATETIME,
    OUT p_id_tarea INT
)
BEGIN
    INSERT INTO tareas (id_proceso, nombre, descripcion, orden_ejecucion, tipo_tarea, prioridad, fecha_limite)
    VALUES (p_id_proceso, p_nombre, p_descripcion, p_orden_ejecucion, p_tipo_tarea, p_prioridad, p_fecha_limite);
    
    SET p_id_tarea = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'Tareas', 'tareas', p_id_tarea, 'crear', CONCAT('Nueva tarea creada: ', p_nombre, ' para el proceso ID: ', p_id_proceso));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_transicion`(
    IN p_proceso_id INT,
    IN p_tarea_origen_id INT,
    IN p_tarea_destino_id INT,
    IN p_condiciones TEXT,
    IN p_tipo_transicion ENUM('automatica','manual','condicional'),
    OUT p_id_flujo INT
)
BEGIN
    INSERT INTO flujoprocesos (proceso_id, tarea_origen_id, tarea_destino_id, condiciones, tipo_transicion)
    VALUES (p_proceso_id, p_tarea_origen_id, p_tarea_destino_id, p_condiciones, p_tipo_transicion);
    
    SET p_id_flujo = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (NULL, 'FlujoProcesos', 'flujoprocesos', p_id_flujo, 'crear', 
            CONCAT('Nueva transición creada del proceso ID: ', p_proceso_id, 
                   ' desde tarea ID: ', p_tarea_origen_id, ' a tarea ID: ', p_tarea_destino_id));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_usuario`(
	IN `p_nombre` VARCHAR(100),
	IN `p_correo` VARCHAR(100),
	IN `p_contrasena` TEXT,
	IN `p_rol_id` INT,
	IN `p_departamento_id` INT
)
BEGIN
	 DECLARE p_id_usuario INT ;
    DECLARE v_salt VARCHAR(64);

    -- Generar un salt seguro
    SET v_salt = SHA2(CAST(RAND() AS CHAR), 256);

    -- Insertar en tabla usuarios
    INSERT INTO usuarios (nombre, correo, contraseña_hash, salt, rol_id, departamento_id)
    VALUES (
        p_nombre,
        p_correo,
        SHA2(CONCAT(p_contrasena, v_salt), 256),
        v_salt,
        p_rol_id,
        p_departamento_id
    );

    -- Obtener el ID generado
    SET p_id_usuario = LAST_INSERT_ID();

    -- Insertar en tabla de auditoría
    INSERT INTO auditoria (
        id_usuario,
        modulo,
        entidad_afectada,
        id_entidad_afectada,
        accion,
        detalles
    )
    VALUES (
        NULL,
        'Usuarios',
        'usuarios',
        p_id_usuario,
        'crear',
        CONCAT('Nuevo usuario creado: ', p_nombre)
    );
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_crear_version_proceso`(
    IN p_proceso_id INT,
    IN p_version VARCHAR(20),
    IN p_descripcion_cambios TEXT,
    IN p_creado_por INT,
    OUT p_id_version INT
)
BEGIN
    INSERT INTO versionesprocesos (proceso_id, version, descripcion_cambios, creado_por)
    VALUES (p_proceso_id, p_version, p_descripcion_cambios, p_creado_por);
    
    SET p_id_version = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_creado_por, 'Versiones', 'versionesprocesos', p_id_version, 'crear', 
            CONCAT('Nueva versión ', p_version, ' creada para el proceso ID: ', p_proceso_id));
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_desasignar_tarea`(
    IN p_id_asignacion INT,
    IN p_usuario_desasignador INT
)
BEGIN
    DECLARE v_tarea_nombre VARCHAR(100);
    DECLARE v_usuario_nombre VARCHAR(100);
    DECLARE v_rol_asignacion VARCHAR(20);
    DECLARE v_usuario_id INT;
    DECLARE v_tarea_id INT;
    
    -- Obtener información de la asignación
    SELECT a.rol_asignacion, u.nombre, t.nombre, a.usuario_id, a.tarea_id
    INTO v_rol_asignacion, v_usuario_nombre, v_tarea_nombre, v_usuario_id, v_tarea_id
    FROM asignacionestareas a
    JOIN usuarios u ON a.usuario_id = u.id_usuario
    JOIN tareas t ON a.tarea_id = t.id_tarea
    WHERE a.id_asignacion = p_id_asignacion;
    
    -- Eliminar la asignación
    DELETE FROM asignacionestareas WHERE id_asignacion = p_id_asignacion;
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_desasignador, 'Asignaciones', 'asignacionestareas', p_id_asignacion, 'desasignar', 
            CONCAT('Usuario ', v_usuario_nombre, ' desasignado como ', v_rol_asignacion, ' de la tarea: ', v_tarea_nombre));
    
    -- Crear notificación para el usuario desasignado
    INSERT INTO notificaciones (usuario_destino_id, titulo, mensaje, tipo, entidad_relacionada, id_entidad_relacionada)
    VALUES (v_usuario_id, 'Desasignación de tarea', 
            CONCAT('Has sido desasignado como ', v_rol_asignacion, ' de la tarea "', v_tarea_nombre, '"'), 
            'tarea', 'tareas', v_tarea_id);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_editar_comentario`(
    IN p_id_comentario BIGINT,
    IN p_contenido TEXT,
    IN p_usuario_id INT
)
BEGIN
    UPDATE comentarios 
    SET contenido = p_contenido,
        editado = 1,
        fecha_edicion = NOW()
    WHERE id_comentario = p_id_comentario AND usuario_id = p_usuario_id;
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_id, 'Comentarios', 'comentarios', p_id_comentario, 'editar', 
            'Comentario actualizado por su autor');
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_Loguear_Usuario`(
	IN `xnombre_usuario` VARCHAR (100),
	IN `xcontrasena` VARCHAR (100)
)
    DETERMINISTIC
BEGIN
DECLARE salt VARCHAR (64);
DECLARE hashcontrasena VARCHAR (64);
DECLARE hash_nuevo VARCHAR (64);

SET salt = (SELECT u.salt FROM usuarios u WHERE u.nombre = xnombre_usuario);
SET hash_nuevo = SHA2(CONCAT(xcontrasena, salt),256); 


SELECT u.id_usuario AS id, u.nombre AS `name`, u.correo AS email, u.rol_id AS id_rol, u.departamento_id AS id_apt, u.estado AS state FROM usuarios u WHERE u.nombre = xnombre_usuario AND u.`contraseña_hash` = hash_nuevo;

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_marcar_notificacion_leida`(
    IN p_id_notificacion BIGINT,
    IN p_usuario_id INT
)
BEGIN
    UPDATE notificaciones 
    SET leida = 1,
        fecha_lectura = NOW()
    WHERE id_notificacion = p_id_notificacion AND usuario_destino_id = p_usuario_id;
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_usuario_id, 'Notificaciones', 'notificaciones', p_id_notificacion, 'marcar_leida', 
            'Notificación marcada como leída');
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_asignaciones_tarea`(
    IN p_tarea_id INT
)
BEGIN
    SELECT a.*, 
           u.nombre AS usuario_nombre,
           u.correo AS usuario_correo,
           r.nombre AS rol_nombre
    FROM asignacionestareas a
    JOIN usuarios u ON a.usuario_id = u.id_usuario
    JOIN roles r ON u.rol_id = r.id_rol
    WHERE a.tarea_id = p_tarea_id AND a.estado = 'activa'
    ORDER BY a.rol_asignacion, a.fecha_asignacion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_comentarios`(
    IN p_proceso_id INT,
    IN p_tarea_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT c.*,
           u.nombre AS usuario_nombre,
           u.correo AS usuario_correo
    FROM comentarios c
    JOIN usuarios u ON c.usuario_id = u.id_usuario
    WHERE (p_proceso_id IS NULL OR c.proceso_id = p_proceso_id)
      AND (p_tarea_id IS NULL OR c.tarea_id = p_tarea_id)
    ORDER BY c.fecha_creacion DESC
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_configuracion`(
    IN p_clave VARCHAR(100)
)
BEGIN
    SELECT * FROM configuraciones WHERE clave = p_clave;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_documentos_proceso`(
    IN p_proceso_id INT,
    IN p_tipo_relacion VARCHAR(20)
)
BEGIN
    SELECT pd.*, 
           d.nombre AS documento_nombre,
           d.tipo AS documento_tipo,
           d.tamano AS documento_tamano,
           u.nombre AS subido_por_nombre
    FROM procesosdocumentos pd
    JOIN documentos d ON pd.documento_id = d.id_documento
    JOIN usuarios u ON d.subido_por = u.id_usuario
    WHERE pd.proceso_id = p_proceso_id 
      AND (p_tipo_relacion IS NULL OR pd.tipo_relacion = p_tipo_relacion)
    ORDER BY pd.tipo_relacion, d.nombre;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_estadisticas_procesos`(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_categoria_id INT
)
BEGIN
    -- Procesos por estado
    SELECT p.estado, COUNT(*) AS cantidad
    FROM procesos p
    WHERE (p_categoria_id IS NULL OR p.categoria_id = p_categoria_id)
      AND (p_fecha_inicio IS NULL OR DATE(p.fecha_creacion) >= p_fecha_inicio)
      AND (p_fecha_fin IS NULL OR DATE(p.fecha_creacion) <= p_fecha_fin)
    GROUP BY p.estado;
    
    -- Tiempo promedio por proceso
    SELECT pr.nombre, 
           AVG(TIMESTAMPDIFF(HOUR, t.fecha_inicio, t.fecha_fin)) AS tiempo_promedio_horas,
           COUNT(t.id_tarea) AS tareas_completadas
    FROM tareas t
    JOIN procesos pr ON t.id_proceso = pr.id_proceso
    WHERE t.estado = 'completada'
      AND (p_categoria_id IS NULL OR pr.categoria_id = p_categoria_id)
      AND (p_fecha_inicio IS NULL OR DATE(t.fecha_fin) >= p_fecha_inicio)
      AND (p_fecha_fin IS NULL OR DATE(t.fecha_fin) <= p_fecha_fin)
    GROUP BY t.id_proceso, pr.nombre;
    
    -- Tareas por prioridad
    SELECT t.prioridad, COUNT(*) AS cantidad
    FROM tareas t
    JOIN procesos p ON t.id_proceso = p.id_proceso
    WHERE (p_categoria_id IS NULL OR p.categoria_id = p_categoria_id)
      AND (p_fecha_inicio IS NULL OR DATE(t.fecha_creacion) >= p_fecha_inicio)
      AND (p_fecha_fin IS NULL OR DATE(t.fecha_creacion) <= p_fecha_fin)
    GROUP BY t.prioridad;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_eventos_por_tipo_estado`(
    IN p_tipo_evento VARCHAR(20),
    IN p_estado VARCHAR(20),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT e.*,
           u.nombre AS creado_por_nombre
    FROM eventosautomatizados e
    JOIN usuarios u ON e.creado_por = u.id_usuario
    WHERE (p_tipo_evento IS NULL OR e.tipo_evento = p_tipo_evento)
      AND (p_estado IS NULL OR e.estado = p_estado)
    ORDER BY e.fecha_creacion DESC
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_notificaciones_usuario`(
    IN p_usuario_id INT,
    IN p_no_leidas BOOLEAN,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT n.*
    FROM notificaciones n
    WHERE n.usuario_destino_id = p_usuario_id
      AND (NOT p_no_leidas OR n.leida = 0)
    ORDER BY n.fecha_creacion DESC
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_plantillas_por_categoria`(
    IN p_categoria_id INT,
    IN p_publico BOOLEAN,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT p.*,
           c.nombre AS categoria_nombre,
           u.nombre AS creado_por_nombre
    FROM plantillasprocesos p
    LEFT JOIN categoriasprocesos c ON p.categoria_id = c.id_categoria
    JOIN usuarios u ON p.creado_por = u.id_usuario
    WHERE (p_categoria_id IS NULL OR p.categoria_id = p_categoria_id)
      AND (NOT p_publico OR p.publico = 1)
    ORDER BY p.fecha_creacion DESC
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_procesos_por_estado`(
    IN p_estado VARCHAR(20),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT p.*, 
           c.nombre AS categoria_nombre,
           u1.nombre AS creado_por_nombre,
           u2.nombre AS responsable_nombre
    FROM procesos p
    LEFT JOIN categoriasprocesos c ON p.categoria_id = c.id_categoria
    LEFT JOIN usuarios u1 ON p.creado_por = u1.id_usuario
    LEFT JOIN usuarios u2 ON p.responsable_id = u2.id_usuario
    WHERE p.estado = p_estado
    ORDER BY p.fecha_creacion DESC
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_tarea`(
    IN p_id_tarea INT
)
BEGIN
    SELECT 
        id_tarea,
        id_proceso,
        nombre,
        descripcion,
        estado,
        prioridad,
        fecha_limite,
        fecha_inicio,
        fecha_fin,
        fecha_creacion
    FROM tareas
    WHERE id_tarea = p_id_tarea;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_tareas_por_proceso_estado`(
    IN p_id_proceso INT,
    IN p_estado VARCHAR(20),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT t.*, 
           p.nombre AS proceso_nombre,
           COUNT(a.id_asignacion) AS num_asignados
    FROM tareas t
    JOIN procesos p ON t.id_proceso = p.id_proceso
    LEFT JOIN asignacionestareas a ON t.id_tarea = a.tarea_id AND a.estado = 'activa'
    WHERE t.id_proceso = p_id_proceso 
      AND (p_estado IS NULL OR t.estado = p_estado)
    GROUP BY t.id_tarea
    ORDER BY t.orden_ejecucion, t.fecha_creacion
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_obtener_versiones_proceso`(
    IN p_proceso_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT v.*,
           u.nombre AS creado_por_nombre
    FROM versionesprocesos v
    JOIN usuarios u ON v.creado_por = u.id_usuario
    WHERE v.proceso_id = p_proceso_id
    ORDER BY v.fecha_creacion DESC
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `PA_registrar_metrica`(
    IN p_metrica_id INT,
    IN p_proceso_id INT,
    IN p_tarea_id INT,
    IN p_valor DECIMAL(15,4),
    IN p_registrado_por INT,
    IN p_comentarios TEXT,
    OUT p_id_registro BIGINT
)
BEGIN
    INSERT INTO registrometricas (metrica_id, proceso_id, tarea_id, valor, registrado_por, comentarios)
    VALUES (p_metrica_id, p_proceso_id, p_tarea_id, p_valor, p_registrado_por, p_comentarios);
    
    SET p_id_registro = LAST_INSERT_ID();
    
    -- Registrar en auditoría
    INSERT INTO auditoria (id_usuario, modulo, entidad_afectada, id_entidad_afectada, accion, detalles)
    VALUES (p_registrado_por, 'Métricas', 'registrometricas', p_id_registro, 'registrar', 
            CONCAT('Nuevo registro de métrica ID: ', p_metrica_id, ' con valor: ', p_valor));
END//
DELIMITER ;

CREATE TABLE IF NOT EXISTS `plantillasprocesos` (
  `id_plantilla` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `categoria_id` int DEFAULT NULL,
  `contenido` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `creado_por` int NOT NULL,
  `publico` tinyint(1) DEFAULT '0',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_plantilla`),
  KEY `categoria_id` (`categoria_id`),
  KEY `creado_por` (`creado_por`),
  CONSTRAINT `plantillasprocesos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categoriasprocesos` (`id_categoria`) ON DELETE SET NULL,
  CONSTRAINT `plantillasprocesos_ibfk_2` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `plantillasprocesos_chk_1` CHECK (json_valid(`contenido`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `procesos` (
  `id_proceso` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `categoria_id` int DEFAULT NULL,
  `creado_por` int NOT NULL,
  `responsable_id` int NOT NULL,
  `estado` enum('borrador','activo','en revision','finalizado','archivado') COLLATE utf8mb4_unicode_ci DEFAULT 'borrador',
  `version` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1.0',
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_proceso`),
  KEY `creado_por` (`creado_por`),
  KEY `responsable_id` (`responsable_id`),
  KEY `idx_procesos_estado` (`estado`),
  KEY `idx_procesos_categoria` (`categoria_id`),
  CONSTRAINT `procesos_ibfk_1` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `procesos_ibfk_2` FOREIGN KEY (`responsable_id`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `procesos_ibfk_3` FOREIGN KEY (`categoria_id`) REFERENCES `categoriasprocesos` (`id_categoria`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `procesosdocumentos` (
  `id_proceso_documento` int NOT NULL AUTO_INCREMENT,
  `proceso_id` int NOT NULL,
  `documento_id` int NOT NULL,
  `tipo_relacion` enum('plantilla','entrada','salida','referencia') COLLATE utf8mb4_unicode_ci NOT NULL,
  `obligatorio` tinyint(1) DEFAULT '0',
  `fecha_asociacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_proceso_documento`),
  UNIQUE KEY `proceso_id` (`proceso_id`,`documento_id`,`tipo_relacion`),
  KEY `documento_id` (`documento_id`),
  CONSTRAINT `procesosdocumentos_ibfk_1` FOREIGN KEY (`proceso_id`) REFERENCES `procesos` (`id_proceso`) ON DELETE CASCADE,
  CONSTRAINT `procesosdocumentos_ibfk_2` FOREIGN KEY (`documento_id`) REFERENCES `documentos` (`id_documento`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `registrometricas` (
  `id_registro` bigint NOT NULL AUTO_INCREMENT,
  `metrica_id` int NOT NULL,
  `proceso_id` int DEFAULT NULL,
  `tarea_id` int DEFAULT NULL,
  `valor` decimal(15,4) NOT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` int DEFAULT NULL,
  `comentarios` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_registro`),
  KEY `metrica_id` (`metrica_id`),
  KEY `proceso_id` (`proceso_id`),
  KEY `tarea_id` (`tarea_id`),
  KEY `registrado_por` (`registrado_por`),
  CONSTRAINT `registrometricas_ibfk_1` FOREIGN KEY (`metrica_id`) REFERENCES `metricas` (`id_metrica`) ON DELETE CASCADE,
  CONSTRAINT `registrometricas_ibfk_2` FOREIGN KEY (`proceso_id`) REFERENCES `procesos` (`id_proceso`) ON DELETE SET NULL,
  CONSTRAINT `registrometricas_ibfk_3` FOREIGN KEY (`tarea_id`) REFERENCES `tareas` (`id_tarea`) ON DELETE SET NULL,
  CONSTRAINT `registrometricas_ibfk_4` FOREIGN KEY (`registrado_por`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `roles` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `nivel_permisos` int NOT NULL DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `color` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `roles` (`id_rol`, `nombre`, `descripcion`, `nivel_permisos`, `fecha_creacion`, `color`) VALUES
	(1, 'administrador\r\n', 'administrador del sistema acceso a todo', 1, '2025-05-29 19:18:48', 'bg-red-600');

CREATE TABLE IF NOT EXISTS `tareas` (
  `id_tarea` int NOT NULL AUTO_INCREMENT,
  `id_proceso` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `estado` enum('pendiente','en progreso','completada','rechazada','cancelada') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `prioridad` enum('baja','media','alta') COLLATE utf8mb4_unicode_ci DEFAULT 'media',
  `fecha_limite` datetime DEFAULT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tarea`),
  KEY `idx_tareas_proceso` (`id_proceso`),
  KEY `idx_tareas_estado` (`estado`),
  CONSTRAINT `tareas_ibfk_1` FOREIGN KEY (`id_proceso`) REFERENCES `procesos` (`id_proceso`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contraseña_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `salt` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol_id` int NOT NULL,
  `departamento_id` int DEFAULT NULL,
  `estado` enum('activo','inactivo','suspendido') COLLATE utf8mb4_unicode_ci DEFAULT 'activo',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `ultimo_acceso` datetime DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `correo` (`correo`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `rol_id` (`rol_id`),
  KEY `departamento_id` (`departamento_id`),
  CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id_rol`) ON UPDATE CASCADE,
  CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`departamento_id`) REFERENCES `departamentos` (`id_departamento`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `correo`, `contraseña_hash`, `salt`, `rol_id`, `departamento_id`, `estado`, `fecha_creacion`, `ultimo_acceso`) VALUES
	(3, 'crisbebe', 'cabreracristhian66@gmail.com', '0bfe55a3845acd5d943361e81b2288d5427cde9560615f7e2a916e17a02c89bd', 'e25c46931d4749d2eada858617884e43154bc41d5b5ab6961347d150a21bd9ef', 1, 1, 'activo', '2025-06-14 04:39:51', NULL),
	(4, 'DannerDQ', 'dannerdiazquispe2@gmail.com', '2c7741c615ff303b52e0bfd21d0b8f3a8592250867d73fb14e332b207f71f6c7', '20fddf437fdc55f3062e454388f8dc02ea700dfd37616b0ce66fd96eadc3a7ec', 1, 1, 'activo', '2025-06-14 05:27:41', NULL);

CREATE TABLE IF NOT EXISTS `versionesprocesos` (
  `id_version` int NOT NULL AUTO_INCREMENT,
  `proceso_id` int NOT NULL,
  `version` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion_cambios` text COLLATE utf8mb4_unicode_ci,
  `creado_por` int NOT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_version`),
  KEY `proceso_id` (`proceso_id`),
  KEY `creado_por` (`creado_por`),
  CONSTRAINT `versionesprocesos_ibfk_1` FOREIGN KEY (`proceso_id`) REFERENCES `procesos` (`id_proceso`) ON DELETE CASCADE,
  CONSTRAINT `versionesprocesos_ibfk_2` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
