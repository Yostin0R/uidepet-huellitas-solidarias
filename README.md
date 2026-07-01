# UidePet - Huellitas Solidarias

Monorepo del proyecto para la gestión de adopciones responsables de mascotas. Incluye el frontend web y la API REST.

## Estructura

| Carpeta | Descripción | Stack |
|---------|-------------|-------|
| `uidepet-huellitas-solidarias/` | Frontend web | React, Vite, Material UI |
| `uidepet-huellitasSolidarias-Api/` | API REST | Node.js, Express, TypeScript |

## Requisitos

- Node.js 18+
- npm

## Instalación

Desde la raíz del proyecto:

```bash
npm run install:all
```

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

### Publicar en GitHub

1. Crear un repositorio vacío en GitHub (por ejemplo `uidepet-huellitas-solidarias`).
2. Vincular y subir:

```bash
git remote add origin https://github.com/Anyela0515/TU-REPO.git
git branch -M main
git push -u origin main
```
