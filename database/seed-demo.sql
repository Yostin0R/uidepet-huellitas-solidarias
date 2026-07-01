-- UidePet - Huellitas Solidarias
-- Datos de demostración para desarrollo y pruebas locales.
-- Ejecutar después de schema.sql y seed.sql.
--
-- Credenciales demo (contraseña: 123456):
--   usuario@huellitas.com   → adoptante
--   fundacion@huellitas.com → fundación

USE uidepet_huellitas;

-- bcrypt hash de "123456" (cost 10)
SET @demo_password_hash = '$2a$10$EvdBpymvP7uDfI0TFRD6RO3YXLwQWUVYKMDqbWFloYCtyNXHCmbD2';

-- ---------------------------------------------------------------------------
-- Persona adoptante
-- ---------------------------------------------------------------------------

INSERT INTO persona (
  cedula, nombres, apellidos, telefono, correo, direccion, fecha_nacimiento
) VALUES (
  '1712345678',
  'Valentina',
  'Silva',
  '0991234567',
  'usuario@huellitas.com',
  'Av. Mariscal Sucre 123, Quito',
  '2000-05-15'
)
ON DUPLICATE KEY UPDATE
  nombres = VALUES(nombres),
  apellidos = VALUES(apellidos),
  telefono = VALUES(telefono),
  direccion = VALUES(direccion);

-- ---------------------------------------------------------------------------
-- Organización fundación
-- ---------------------------------------------------------------------------

INSERT INTO organizacion (
  nombre,
  tipo,
  ruc,
  representante_legal,
  ciudad,
  telefono,
  correo,
  direccion,
  descripcion,
  estado,
  estado_validacion
) VALUES (
  'Fundación Huellitas Solidarias',
  'FUNDACION',
  '1791234567001',
  'María González',
  'Quito',
  '0223456789',
  'fundacion@huellitas.com',
  'Av. Pedro Vicente Maldonado, Quito',
  'Refugio dedicado al rescate, rehabilitación y adopción responsable de mascotas.',
  'ACTIVA',
  'APROBADA'
)
ON DUPLICATE KEY UPDATE
  representante_legal = VALUES(representante_legal),
  ciudad = VALUES(ciudad),
  telefono = VALUES(telefono),
  direccion = VALUES(direccion),
  descripcion = VALUES(descripcion),
  estado_validacion = VALUES(estado_validacion);

-- ---------------------------------------------------------------------------
-- Cuentas de acceso
-- ---------------------------------------------------------------------------

INSERT INTO cuenta_usuario (
  fk_persona_id,
  usuario,
  password_hash,
  email_verificado,
  estado
)
SELECT
  p.id_persona,
  'usuario@huellitas.com',
  @demo_password_hash,
  1,
  'ACTIVA'
FROM persona p
WHERE p.correo = 'usuario@huellitas.com'
ON DUPLICATE KEY UPDATE
  password_hash = VALUES(password_hash),
  email_verificado = VALUES(email_verificado),
  estado = VALUES(estado);

INSERT INTO cuenta_usuario (
  fk_organizacion_id,
  usuario,
  password_hash,
  email_verificado,
  estado
)
SELECT
  o.id_organizacion,
  'fundacion@huellitas.com',
  @demo_password_hash,
  1,
  'ACTIVA'
FROM organizacion o
WHERE o.correo = 'fundacion@huellitas.com'
ON DUPLICATE KEY UPDATE
  password_hash = VALUES(password_hash),
  email_verificado = VALUES(email_verificado),
  estado = VALUES(estado);

-- ---------------------------------------------------------------------------
-- Roles de las cuentas demo
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO cuenta_rol (fk_cuenta_id, fk_rol_id)
SELECT c.id_cuenta, r.id_rol
FROM cuenta_usuario c
INNER JOIN rol r ON r.nombre_rol = 'ADOPTANTE'
WHERE c.usuario = 'usuario@huellitas.com';

INSERT IGNORE INTO cuenta_rol (fk_cuenta_id, fk_rol_id)
SELECT c.id_cuenta, r.id_rol
FROM cuenta_usuario c
INNER JOIN rol r ON r.nombre_rol = 'FUNDACION'
WHERE c.usuario = 'fundacion@huellitas.com';

-- ---------------------------------------------------------------------------
-- Mascotas disponibles (alineadas con el mock actual de la API)
-- ---------------------------------------------------------------------------

INSERT INTO mascota (
  fk_organizacion_id,
  nombre,
  especie,
  raza,
  sexo,
  edad_aproximada,
  tamano,
  color,
  descripcion,
  esterilizado,
  estado_adopcion
)
SELECT
  o.id_organizacion,
  'Max',
  'PERRO',
  'Mestizo',
  'MACHO',
  '2 anos',
  'MEDIANO',
  'Cafe',
  'Perro sociable y enérgico, ideal para familias activas.',
  'SI',
  'DISPONIBLE'
FROM organizacion o
WHERE o.correo = 'fundacion@huellitas.com'
  AND NOT EXISTS (
    SELECT 1
    FROM mascota m
    WHERE m.fk_organizacion_id = o.id_organizacion
      AND m.nombre = 'Max'
  );

INSERT INTO mascota (
  fk_organizacion_id,
  nombre,
  especie,
  raza,
  sexo,
  edad_aproximada,
  tamano,
  color,
  descripcion,
  esterilizado,
  estado_adopcion
)
SELECT
  o.id_organizacion,
  'Luna',
  'PERRO',
  'Mestizo',
  'HEMBRA',
  '8 meses',
  'PEQUENO',
  'Blanco',
  'Cachorra dócil y cariñosa, se adapta bien a espacios pequeños.',
  'EN_PROCESO',
  'DISPONIBLE'
FROM organizacion o
WHERE o.correo = 'fundacion@huellitas.com'
  AND NOT EXISTS (
    SELECT 1
    FROM mascota m
    WHERE m.fk_organizacion_id = o.id_organizacion
      AND m.nombre = 'Luna'
  );

INSERT INTO mascota (
  fk_organizacion_id,
  nombre,
  especie,
  raza,
  sexo,
  edad_aproximada,
  tamano,
  color,
  descripcion,
  esterilizado,
  estado_adopcion
)
SELECT
  o.id_organizacion,
  'Sombra',
  'GATO',
  'Mestizo',
  'MACHO',
  '3 anos',
  'MEDIANO',
  'Negro',
  'Gato independiente y tranquilo, perfecto para departamento.',
  'SI',
  'DISPONIBLE'
FROM organizacion o
WHERE o.correo = 'fundacion@huellitas.com'
  AND NOT EXISTS (
    SELECT 1
    FROM mascota m
    WHERE m.fk_organizacion_id = o.id_organizacion
      AND m.nombre = 'Sombra'
  );
