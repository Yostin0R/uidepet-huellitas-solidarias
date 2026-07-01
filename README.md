# UidePet - Huellitas Solidarias

Monorepo del proyecto para la gestión de adopciones responsables de mascotas. Incluye el frontend web y la API REST.

## Estructura

| Carpeta | Descripción | Stack |
|---------|-------------|-------|
| `database/` | Esquema MySQL, seeds y Docker | MySQL 8 |
| `uidepet-huellitas-solidarias/` | Frontend web | React, Vite, Material UI |
| `uidepet-huellitasSolidarias-Api/` | API REST | Node.js, Express, TypeScript |

## Requisitos

- Node.js 18+
- npm
- MySQL 8+ **o** Docker (para la base de datos)

## Instalación

Desde la raíz del proyecto:

```bash
npm run install:all
```

## Base de datos

Scripts en `database/`:

```bash
cd database
docker compose up -d
```

O con MySQL local:

```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seed.sql
mysql -u root -p < database/seed-demo.sql
```

Credenciales demo (contraseña `123456`):

- `usuario@huellitas.com` — adoptante
- `fundacion@huellitas.com` — fundación

Detalle completo en [database/README.md](database/README.md).

## Variables de entorno (API)

Crear `uidepet-huellitasSolidarias-Api/.env`:

```env
PORT=3000
JWT_SECRET=tu-secreto-seguro
```

## Ejecución

En dos terminales:

```bash
# Terminal 1 - API
npm run dev:api

# Terminal 2 - Frontend
npm run dev:web
```

- API: http://localhost:3000
- Frontend: http://localhost:5173

El frontend redirige `/v1`, `/v2` y `/health` hacia la API en desarrollo.

## Build

```bash
npm run build:api
npm run build:web
```

## Repositorio

Este es el **repositorio principal** del proyecto. Los repos anteriores del frontend y la API quedaron unificados aquí:

- Frontend (histórico): https://github.com/Anyela0515/uidepet-huellitas-solidarias
- API (histórico): https://github.com/Anyela0515/uidepet-huellitasSolidarias-Api


