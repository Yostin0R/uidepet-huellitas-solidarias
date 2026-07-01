# Base de datos — UidePet Huellitas Solidarias

Esquema MySQL 8+ para la plataforma de adopción responsable.

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `schema.sql` | Crea la BD `uidepet_huellitas` y las 24 tablas |
| `seed.sql` | Roles del sistema (idempotente) |
| `seed-demo.sql` | Usuarios, fundación y mascotas de prueba |
| `docker-compose.yml` | MySQL 8 listo para desarrollo |
| `install.ps1` / `install.sh` | Instalación manual en un solo comando |

## Requisitos

- MySQL 8.0+ **o** Docker Desktop

## Opción A — Docker (recomendada)

Desde esta carpeta:

```bash
docker compose up -d
```

MySQL queda en `localhost:3306` con:

| Variable | Valor |
|----------|-------|
| Host | `127.0.0.1` |
| Puerto | `3306` |
| Usuario | `root` |
| Contraseña | `root` |
| Base de datos | `uidepet_huellitas` |

Los scripts `schema.sql`, `seed.sql` y `seed-demo.sql` se aplican automáticamente al crear el contenedor.

Verificar:

```bash
docker compose exec mysql mysql -uroot -proot -e "USE uidepet_huellitas; SHOW TABLES; SELECT COUNT(*) AS mascotas FROM mascota;"
```

Detener:

```bash
docker compose down
```

Recrear desde cero (borra datos):

```bash
docker compose down -v
docker compose up -d
```

## Opción B — MySQL local

### Windows (PowerShell)

```powershell
cd database
.\install.ps1 -User root -Password tu_clave
```

### Linux / macOS

```bash
cd database
chmod +x install.sh
./install.sh -u root -p tu_clave
```

### Manual

```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seed.sql
mysql -u root -p < database/seed-demo.sql
```

## Credenciales demo

Contraseña de ambas cuentas: **`123456`**

| Usuario | Rol | Uso |
|---------|-----|-----|
| `usuario@huellitas.com` | ADOPTANTE | Login adoptante |
| `fundacion@huellitas.com` | FUNDACION | Login fundación |

Las contraseñas están almacenadas con **bcrypt** en `cuenta_usuario.password_hash`.

## Datos demo incluidos

- 1 adoptante (`Valentina Silva`)
- 1 fundación aprobada (`Fundación Huellitas Solidarias`)
- 3 mascotas disponibles: **Max**, **Luna**, **Sombra**

## Diagrama ER

El modelo conceptual está en `diagrama.mwb` (MySQL Workbench), cuando se incluya en el repositorio.

## Variables para la API (futuro)

Cuando conectes la API, usa en `.env`:

```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=root
DB_NAME=uidepet_huellitas
```
