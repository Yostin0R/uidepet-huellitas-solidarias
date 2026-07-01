-- UidePet - Huellitas Solidarias
-- Datos iniciales de catálogo (roles del sistema)

USE uidepet_huellitas;

INSERT INTO rol (nombre_rol, descripcion) VALUES
  ('ADOPTANTE', 'Persona natural que puede solicitar adopciones y donaciones'),
  ('FUNDACION', 'Organización registrada que publica mascotas y gestiona adopciones'),
  ('ADMIN_UIDE', 'Administrador institucional de la plataforma UIDE'),
  ('VETERINARIO', 'Profesional o clínica con acceso a atención veterinaria y carnets'),
  ('VOLUNTARIO', 'Persona aprobada para apoyar actividades de una organización'),
  ('MODERADOR', 'Usuario con permisos de revisión de denuncias y validación de fundaciones');
