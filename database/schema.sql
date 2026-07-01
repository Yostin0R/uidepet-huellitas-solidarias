-- UidePet - Huellitas Solidarias
-- Esquema MySQL 8+ basado en GA-2.4_Grupo3_EsquemaConceptual.mwb
-- Incluye mejoras de integridad, auditoría y alineación con frontend/API.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS uidepet_huellitas;
CREATE DATABASE uidepet_huellitas
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE uidepet_huellitas;

-- ---------------------------------------------------------------------------
-- Catálogos y actores
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS rol (
  id_rol INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre_rol VARCHAR(40) NOT NULL,
  descripcion VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_rol_nombre (nombre_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS persona (
  id_persona INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  cedula CHAR(10) NOT NULL,
  nombres VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  telefono VARCHAR(10) NOT NULL,
  correo VARCHAR(100) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  foto_persona_url VARCHAR(255) NULL,
  estado ENUM('ACTIVO', 'INACTIVO', 'RESTRINGIDO') NOT NULL DEFAULT 'ACTIVO',
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_persona_cedula (cedula),
  UNIQUE KEY uk_persona_correo (correo),
  KEY idx_persona_estado (estado),
  CONSTRAINT chk_persona_cedula CHECK (cedula REGEXP '^[0-9]{10}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS organizacion (
  id_organizacion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  tipo ENUM(
    'REFUGIO', 'FUNDACION', 'COLECTIVO',
    'RESCATISTA_INDEPENDIENTE', 'UIDE', 'MUNICIPIO', 'VETERINARIA'
  ) NOT NULL,
  ruc CHAR(13) NULL,
  representante_legal VARCHAR(150) NOT NULL,
  ciudad VARCHAR(80) NOT NULL,
  telefono VARCHAR(10) NOT NULL,
  correo VARCHAR(100) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  sitio_web VARCHAR(255) NULL,
  descripcion TEXT NULL,
  documento_respaldo_url VARCHAR(255) NULL,
  estado ENUM('ACTIVA', 'INACTIVA') NOT NULL DEFAULT 'ACTIVA',
  estado_validacion ENUM('PENDIENTE', 'APROBADA', 'RECHAZADA') NOT NULL DEFAULT 'PENDIENTE',
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_organizacion_nombre (nombre),
  UNIQUE KEY uk_organizacion_correo (correo),
  UNIQUE KEY uk_organizacion_ruc (ruc),
  KEY idx_organizacion_tipo (tipo),
  KEY idx_organizacion_estado (estado),
  KEY idx_organizacion_validacion (estado_validacion),
  CONSTRAINT chk_organizacion_ruc CHECK (ruc IS NULL OR ruc REGEXP '^[0-9]{13}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cuenta_usuario (
  id_cuenta INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_persona_id INT UNSIGNED NULL,
  fk_organizacion_id INT UNSIGNED NULL,
  usuario VARCHAR(60) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  estado ENUM('ACTIVA', 'INACTIVA', 'BLOQUEADA') NOT NULL DEFAULT 'ACTIVA',
  email_verificado TINYINT(1) NOT NULL DEFAULT 0,
  intentos_fallidos TINYINT UNSIGNED NOT NULL DEFAULT 0,
  bloqueado_hasta DATETIME NULL,
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultimo_acceso DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uk_cuenta_usuario (usuario),
  UNIQUE KEY uk_cuenta_persona (fk_persona_id),
  UNIQUE KEY uk_cuenta_organizacion (fk_organizacion_id),
  KEY idx_cuenta_estado (estado),

  CONSTRAINT fk_cuenta_persona
    FOREIGN KEY (fk_persona_id) REFERENCES persona (id_persona)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_cuenta_organizacion
    FOREIGN KEY (fk_organizacion_id) REFERENCES organizacion (id_organizacion)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cuenta_rol (
  fk_cuenta_id INT UNSIGNED NOT NULL,
  fk_rol_id INT UNSIGNED NOT NULL,
  fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (fk_cuenta_id, fk_rol_id),
  KEY idx_cuenta_rol_rol (fk_rol_id),
  CONSTRAINT fk_cuenta_rol_cuenta
    FOREIGN KEY (fk_cuenta_id) REFERENCES cuenta_usuario (id_cuenta)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_cuenta_rol_rol
    FOREIGN KEY (fk_rol_id) REFERENCES rol (id_rol)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Mascotas y salud
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS mascota (
  id_mascota INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_organizacion_id INT UNSIGNED NOT NULL,
  nombre VARCHAR(80) NOT NULL,
  especie ENUM('PERRO', 'GATO', 'CONEJO', 'OTRO') NOT NULL,
  raza VARCHAR(80) NOT NULL DEFAULT 'MESTIZO',
  sexo ENUM('MACHO', 'HEMBRA', 'DESCONOCIDO') NOT NULL,
  edad_aproximada VARCHAR(50) NOT NULL,
  tamano ENUM('PEQUENO', 'MEDIANO', 'GRANDE', 'NO_APLICA') NOT NULL DEFAULT 'NO_APLICA',
  color VARCHAR(80) NULL,
  descripcion TEXT NULL,
  historia TEXT NULL,
  estado_salud VARCHAR(150) NULL,
  esterilizado ENUM('SI', 'NO', 'EN_PROCESO') NOT NULL DEFAULT 'EN_PROCESO',
  motivo_no_esterilizacion ENUM('EDAD', 'ENFERMEDAD', 'EN_PROCESO') NULL,
  estado_adopcion ENUM(
    'NO_DISPONIBLE', 'DISPONIBLE', 'EN_PROCESO', 'ADOPTADO', 'FALLECIDO'
  ) NOT NULL DEFAULT 'NO_DISPONIBLE',
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_mascota_organizacion (fk_organizacion_id),
  KEY idx_mascota_especie (especie),
  KEY idx_mascota_estado (estado_adopcion),
  KEY idx_mascota_catalogo (estado_adopcion, fk_organizacion_id),
  CONSTRAINT fk_mascota_organizacion
    FOREIGN KEY (fk_organizacion_id) REFERENCES organizacion (id_organizacion)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS foto_mascota (
  id_foto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_mascota_id INT UNSIGNED NOT NULL,
  foto_url VARCHAR(255) NOT NULL,
  descripcion VARCHAR(255) NULL,
  es_principal TINYINT(1) NOT NULL DEFAULT 0,
  fecha_subida DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_foto_mascota (fk_mascota_id),
  CONSTRAINT fk_foto_mascota
    FOREIGN KEY (fk_mascota_id) REFERENCES mascota (id_mascota)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS atencion_veterinaria (
  id_atencion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_mascota_id INT UNSIGNED NOT NULL,
  veterinaria VARCHAR(150) NOT NULL,
  fecha_ingreso DATE NOT NULL,
  fecha_salida DATE NULL,
  examenes_realizados TEXT NULL,
  desparasitacion_interna ENUM('SI', 'NO', 'EN_PROCESO') NOT NULL DEFAULT 'EN_PROCESO',
  desparasitacion_externa ENUM('SI', 'NO', 'EN_PROCESO') NOT NULL DEFAULT 'EN_PROCESO',
  vacunacion_realizada ENUM('SI', 'NO', 'EN_PROCESO') NOT NULL DEFAULT 'EN_PROCESO',
  esterilizacion_realizada ENUM('SI', 'NO', 'EN_PROCESO') NOT NULL DEFAULT 'EN_PROCESO',
  motivo_no_esterilizacion ENUM('EDAD', 'ENFERMEDAD', 'EN_PROCESO') NULL,
  diagnostico TEXT NULL,
  apto_para_adopcion ENUM('SI', 'NO', 'EN_OBSERVACION') NOT NULL DEFAULT 'EN_OBSERVACION',
  KEY idx_atencion_mascota (fk_mascota_id),
  KEY idx_atencion_apto (apto_para_adopcion),
  CONSTRAINT fk_atencion_mascota
    FOREIGN KEY (fk_mascota_id) REFERENCES mascota (id_mascota)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS carnet_vacunacion (
  id_carnet INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_mascota_id INT UNSIGNED NOT NULL,
  archivo_carnet_url VARCHAR(255) NOT NULL,
  vacunas_al_dia ENUM('SI', 'NO', 'EN_PROCESO') NOT NULL DEFAULT 'EN_PROCESO',
  fecha_actualizacion DATE NOT NULL,
  estado ENUM('VIGENTE', 'VENCIDO', 'EN_REVISION') NOT NULL DEFAULT 'VIGENTE',
  observaciones TEXT NULL,
  UNIQUE KEY uk_carnet_mascota (fk_mascota_id),
  CONSTRAINT fk_carnet_mascota
    FOREIGN KEY (fk_mascota_id) REFERENCES mascota (id_mascota)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS vacuna_aplicada (
  id_vacuna_aplicada INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_carnet_id INT UNSIGNED NOT NULL,
  nombre_vacuna VARCHAR(100) NOT NULL,
  fecha_aplicacion DATE NOT NULL,
  proxima_dosis DATE NULL,
  veterinaria VARCHAR(100) NULL,
  KEY idx_vacuna_carnet (fk_carnet_id),
  CONSTRAINT fk_vacuna_carnet
    FOREIGN KEY (fk_carnet_id) REFERENCES carnet_vacunacion (id_carnet)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Adopción
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS solicitud_adopcion (
  id_solicitud INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_adoptante_id INT UNSIGNED NOT NULL,
  fk_mascota_id INT UNSIGNED NOT NULL,
  fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('PENDIENTE', 'EN_REVISION', 'APROBADA', 'RECHAZADA', 'CANCELADA')
    NOT NULL DEFAULT 'PENDIENTE',
  motivo_adopcion TEXT NOT NULL,
  motivo_rechazo VARCHAR(255) NULL,
  observaciones VARCHAR(255) NULL,
  acepta_seguimiento TINYINT(1) NOT NULL DEFAULT 0,
  canal_seguimiento ENUM('whatsapp', 'correo', 'telefono') NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_solicitud_adoptante (fk_adoptante_id),
  KEY idx_solicitud_mascota (fk_mascota_id),
  KEY idx_solicitud_estado (estado),
  KEY idx_solicitud_adoptante_mascota (fk_adoptante_id, fk_mascota_id),
  KEY idx_solicitud_bandeja (estado, fecha_solicitud),
  CONSTRAINT fk_solicitud_adoptante
    FOREIGN KEY (fk_adoptante_id) REFERENCES persona (id_persona)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_solicitud_mascota
    FOREIGN KEY (fk_mascota_id) REFERENCES mascota (id_mascota)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_canal_seguimiento CHECK (
    (acepta_seguimiento = 0 AND canal_seguimiento IS NULL)
    OR (acepta_seguimiento = 1 AND canal_seguimiento IS NOT NULL)
  )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS vivienda_adopcion (
  id_vivienda INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_solicitud_id INT UNSIGNED NOT NULL,
  direccion_exacta VARCHAR(255) NOT NULL,
  latitud DECIMAL(10, 8) NOT NULL,
  longitud DECIMAL(11, 8) NOT NULL,
  foto_lugar_url VARCHAR(255) NULL,
  video_lugar_url VARCHAR(255) NULL,
  tiene_cerramiento TINYINT(1) NOT NULL DEFAULT 0,
  tiene_zona_verde TINYINT(1) NOT NULL DEFAULT 0,
  zona_verde_segura TINYINT(1) NULL,
  mascota_vivira_dentro_casa TINYINT(1) NOT NULL DEFAULT 0,
  espacio_adecuado TINYINT(1) NOT NULL DEFAULT 0,
  cama_lista TINYINT(1) NOT NULL DEFAULT 0,
  platos_listos TINYINT(1) NOT NULL DEFAULT 0,
  lugar_permanencia VARCHAR(150) NOT NULL,
  UNIQUE KEY uk_vivienda_solicitud (fk_solicitud_id),
  CONSTRAINT fk_vivienda_solicitud
    FOREIGN KEY (fk_solicitud_id) REFERENCES solicitud_adopcion (id_solicitud)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS hogar_adopcion (
  id_hogar INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_solicitud_id INT UNSIGNED NOT NULL,
  cantidad_personas_hogar TINYINT UNSIGNED NOT NULL,
  todos_de_acuerdo TINYINT(1) NOT NULL DEFAULT 0,
  converso_con_familia TINYINT(1) NOT NULL DEFAULT 0,
  observaciones TEXT NULL,
  UNIQUE KEY uk_hogar_solicitud (fk_solicitud_id),
  CONSTRAINT fk_hogar_solicitud
    FOREIGN KEY (fk_solicitud_id) REFERENCES solicitud_adopcion (id_solicitud)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS otra_mascota_solicitud (
  id_otra_mascota INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_solicitud_id INT UNSIGNED NOT NULL,
  nombre VARCHAR(80) NOT NULL,
  especie ENUM('PERRO', 'GATO', 'CONEJO', 'OTRO') NOT NULL,
  esterilizada TINYINT(1) NULL,
  vacunas_al_dia ENUM('SI', 'NO', 'EN_PROCESO') NOT NULL DEFAULT 'EN_PROCESO',
  KEY idx_otra_mascota_solicitud (fk_solicitud_id),
  CONSTRAINT fk_otra_mascota_solicitud
    FOREIGN KEY (fk_solicitud_id) REFERENCES solicitud_adopcion (id_solicitud)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS responsable_manutencion (
  id_responsable INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_solicitud_id INT UNSIGNED NOT NULL,
  nombres_responsable VARCHAR(100) NOT NULL,
  apellidos_responsable VARCHAR(100) NOT NULL,
  parentesco VARCHAR(50) NOT NULL,
  telefono_responsable VARCHAR(10) NOT NULL,
  lugar_trabajo VARCHAR(150) NOT NULL,
  ingreso_mensual DECIMAL(10, 2) NULL,
  UNIQUE KEY uk_responsable_solicitud (fk_solicitud_id),
  CONSTRAINT fk_responsable_solicitud
    FOREIGN KEY (fk_solicitud_id) REFERENCES solicitud_adopcion (id_solicitud)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS adopcion (
  id_adopcion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_solicitud_id INT UNSIGNED NOT NULL,
  fk_atencion_id INT UNSIGNED NULL,
  fecha_entrega DATE NOT NULL,
  acta_compromiso_url VARCHAR(255) NOT NULL,
  estado ENUM('ACTIVA', 'FINALIZADA', 'REVERSADA') NOT NULL DEFAULT 'ACTIVA',
  UNIQUE KEY uk_adopcion_solicitud (fk_solicitud_id),
  KEY idx_adopcion_atencion (fk_atencion_id),
  KEY idx_adopcion_estado (estado),
  CONSTRAINT fk_adopcion_solicitud
    FOREIGN KEY (fk_solicitud_id) REFERENCES solicitud_adopcion (id_solicitud)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_adopcion_atencion
    FOREIGN KEY (fk_atencion_id) REFERENCES atencion_veterinaria (id_atencion)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS seguimiento_adopcion (
  id_seguimiento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_adopcion_id INT UNSIGNED NOT NULL,
  fecha_seguimiento DATE NOT NULL,
  tipo_seguimiento ENUM('VISITA', 'FOTO', 'VIDEO', 'VIDEOLLAMADA', 'MENSAJE') NOT NULL,
  evidencia_url VARCHAR(255) NULL,
  estado_mascota ENUM('BIEN', 'REGULAR', 'MAL', 'NO_VERIFICADO') NOT NULL DEFAULT 'NO_VERIFICADO',
  observaciones TEXT NULL,
  KEY idx_seguimiento_adopcion (fk_adopcion_id),
  KEY idx_seguimiento_fecha (fk_adopcion_id, fecha_seguimiento),
  CONSTRAINT fk_seguimiento_adopcion
    FOREIGN KEY (fk_adopcion_id) REFERENCES adopcion (id_adopcion)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Denuncias, rescates y hogares temporales
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS denuncia_maltrato (
  id_denuncia INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_reportante_id INT UNSIGNED NOT NULL,
  fk_organizacion_id INT UNSIGNED NOT NULL,
  tipo_denuncia ENUM('ABANDONO', 'MALTRATO', 'VENTA_ILEGAL', 'ANIMAL_PERDIDO', 'OTRO') NOT NULL,
  descripcion TEXT NOT NULL,
  direccion_referencia VARCHAR(255) NOT NULL,
  latitud DECIMAL(10, 8) NULL,
  longitud DECIMAL(11, 8) NULL,
  evidencia_url VARCHAR(255) NULL,
  estado ENUM('RECIBIDA', 'EN_REVISION', 'ATENDIDA', 'CERRADA') NOT NULL DEFAULT 'RECIBIDA',
  fecha_denuncia DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_denuncia_reportante (fk_reportante_id),
  KEY idx_denuncia_organizacion (fk_organizacion_id),
  KEY idx_denuncia_estado (estado),
  CONSTRAINT fk_denuncia_persona
    FOREIGN KEY (fk_reportante_id) REFERENCES persona (id_persona)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_denuncia_organizacion
    FOREIGN KEY (fk_organizacion_id) REFERENCES organizacion (id_organizacion)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS rescate (
  id_rescate INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_mascota_id INT UNSIGNED NOT NULL,
  fk_denuncia_id INT UNSIGNED NULL,
  fk_organizacion_id INT UNSIGNED NOT NULL,
  fecha_rescate DATE NOT NULL,
  lugar_rescate VARCHAR(255) NOT NULL,
  latitud DECIMAL(10, 8) NULL,
  longitud DECIMAL(11, 8) NULL,
  descripcion_rescate TEXT NOT NULL,
  estado ENUM('REPORTADO', 'RESCATADO', 'EN_VETERINARIA', 'EN_REFUGIO', 'CERRADO')
    NOT NULL DEFAULT 'REPORTADO',
  KEY idx_rescate_mascota (fk_mascota_id),
  KEY idx_rescate_denuncia (fk_denuncia_id),
  KEY idx_rescate_organizacion (fk_organizacion_id),
  KEY idx_rescate_estado (estado),
  CONSTRAINT fk_rescate_mascota
    FOREIGN KEY (fk_mascota_id) REFERENCES mascota (id_mascota)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_rescate_denuncia
    FOREIGN KEY (fk_denuncia_id) REFERENCES denuncia_maltrato (id_denuncia)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_rescate_organizacion
    FOREIGN KEY (fk_organizacion_id) REFERENCES organizacion (id_organizacion)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS hogar_temporal (
  id_hogar_temporal INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_persona_id INT UNSIGNED NOT NULL,
  fk_mascota_id INT UNSIGNED NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NULL,
  direccion VARCHAR(255) NOT NULL,
  latitud DECIMAL(10, 8) NULL,
  longitud DECIMAL(11, 8) NULL,
  estado ENUM('PENDIENTE', 'ACTIVO', 'FINALIZADO', 'CANCELADO') NOT NULL DEFAULT 'PENDIENTE',
  KEY idx_hogar_temporal_persona (fk_persona_id),
  KEY idx_hogar_temporal_mascota (fk_mascota_id),
  KEY idx_hogar_temporal_estado (estado),
  CONSTRAINT fk_hogar_temporal_persona
    FOREIGN KEY (fk_persona_id) REFERENCES persona (id_persona)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_hogar_temporal_mascota
    FOREIGN KEY (fk_mascota_id) REFERENCES mascota (id_mascota)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Campañas, donaciones y voluntariado
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS campana (
  id_campana INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_organizacion_id INT UNSIGNED NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  tipo_campana ENUM(
    'ADOPCION', 'DONACION', 'DESPARASITACION', 'VOLUNTARIADO', 'BINGO', 'OTRO'
  ) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  lugar VARCHAR(255) NOT NULL,
  latitud DECIMAL(10, 8) NULL,
  longitud DECIMAL(11, 8) NULL,
  descripcion TEXT NULL,
  estado ENUM('PLANIFICADA', 'ACTIVA', 'FINALIZADA', 'CANCELADA') NOT NULL DEFAULT 'PLANIFICADA',
  KEY idx_campana_organizacion (fk_organizacion_id),
  KEY idx_campana_estado (estado),
  KEY idx_campana_fechas (fecha_inicio, fecha_fin, estado),
  CONSTRAINT fk_campana_organizacion
    FOREIGN KEY (fk_organizacion_id) REFERENCES organizacion (id_organizacion)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS campana_mascota (
  id_campana_mascota INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_campana_id INT UNSIGNED NOT NULL,
  fk_mascota_id INT UNSIGNED NOT NULL,
  fecha_participacion DATE NOT NULL,
  resultado ENUM('PRESENTADA', 'INTERESADOS', 'ADOPTADA', 'SIN_RESULTADO') NOT NULL,
  UNIQUE KEY uk_campana_mascota_fecha (fk_campana_id, fk_mascota_id, fecha_participacion),
  KEY idx_campana_mascota_mascota (fk_mascota_id),
  CONSTRAINT fk_campana_mascota_campana
    FOREIGN KEY (fk_campana_id) REFERENCES campana (id_campana)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_campana_mascota_mascota
    FOREIGN KEY (fk_mascota_id) REFERENCES mascota (id_mascota)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS donacion (
  id_donacion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_persona_id INT UNSIGNED NOT NULL,
  fk_organizacion_id INT UNSIGNED NOT NULL,
  tipo_donacion ENUM(
    'ECONOMICA', 'ALIMENTO', 'MEDICAMENTO', 'VETERINARIA',
    'TRANSPORTE', 'APADRINAMIENTO', 'OTRO'
  ) NOT NULL,
  descripcion TEXT NOT NULL,
  monto DECIMAL(10, 2) NULL,
  fecha_donacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('REGISTRADA', 'CONFIRMADA', 'ANULADA') NOT NULL DEFAULT 'REGISTRADA',
  KEY idx_donacion_persona (fk_persona_id),
  KEY idx_donacion_organizacion (fk_organizacion_id),
  KEY idx_donacion_tipo (tipo_donacion),
  KEY idx_donacion_estado (estado),
  CONSTRAINT fk_donacion_persona
    FOREIGN KEY (fk_persona_id) REFERENCES persona (id_persona)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_donacion_organizacion
    FOREIGN KEY (fk_organizacion_id) REFERENCES organizacion (id_organizacion)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE solicitud_voluntariado (
  id_voluntariado INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fk_persona_id INT UNSIGNED NOT NULL,
  fk_organizacion_id INT UNSIGNED NOT NULL,
  actividad_interes ENUM(
    'BANAR', 'ALIMENTAR', 'TRANSPORTE', 'EVENTO',
    'DIFUSION', 'CUIDADO', 'DENUNCIAS', 'OTRO'
  ) NOT NULL,
  disponibilidad VARCHAR(150) NOT NULL,
  fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('PENDIENTE', 'APROBADO', 'RECHAZADO', 'INACTIVO') NOT NULL DEFAULT 'PENDIENTE',
  KEY idx_voluntariado_persona (fk_persona_id),
  KEY idx_voluntariado_organizacion (fk_organizacion_id),
  KEY idx_voluntariado_estado (estado),
  CONSTRAINT fk_voluntariado_persona
    FOREIGN KEY (fk_persona_id) REFERENCES persona (id_persona)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_voluntariado_organizacion
    FOREIGN KEY (fk_organizacion_id) REFERENCES organizacion (id_organizacion)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
