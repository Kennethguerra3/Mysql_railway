# MySQL en Railway

Este repositorio contiene la configuración para desplegar un servidor MySQL optimizado en Railway.

## 📋 Requisitos Previos

- Una cuenta en [Railway](https://railway.app/)
- Railway CLI instalado (opcional, recomendado)

## 🚀 Despliegue Rápido

1. **Nuevo Proyecto**: En Railway, crea un `New Project` > `Empty Project`.
2. **Servicio**: Añade un servicio seleccionando este repositorio o subiendo el código.
3. **Variables de Entorno**: Configura las siguientes variables **ANTES** del despliegue:

### Variables Obligatorias

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `MYSQL_ROOT_PASSWORD` | Contraseña para el usuario `root`. | `MiPasswordSeguro123!` |
| `MYSQL_DATABASE` | (Opcional) Crea una base de datos al iniciar. | `mi_base_datos` |
| `MYSQL_USER` | (Opcional) Crea un usuario adicional. | `app_user` |
| `MYSQL_PASSWORD` | (Opcional) Contraseña para `MYSQL_USER`. | `AppPass123!` |

### Variables de Sistema (Ya configuradas en Dockerfile)

- `TZ`: `America/Lima`

## 💾 Configuración de Volumen (Persistencia)

Para evitar perder los datos al reiniciar el servicio, **DEBES** configurar un volumen en Railway.

1. Ve a la pestaña **Settings** de tu servicio en Railway.
2. Busca la sección **Volumes**.
3. Haz clic en **+ Add Volume**.
4. Usa la siguiente ruta de montaje (`Mount Path`):

run
/var/lib/mysql


> **⚠️ IMPORTANTE**: Si no configuras este volumen, ¡todos tus datos se perderán cada vez que se redespliegue el servicio!

## 🛠️ Conexión

### Desde otro servicio en Railway (Red Privada)
Usa las variables que Railway provee automáticamente o conecta usando:
- **Host**: `${RAILWAY_PRIVATE_DOMAIN}` (o el nombre del servicio)
- **Port**: `3306`

### Desde tu PC (Red Pública)
1. Ve a **Settings** > **Networking**.
2. Genera un dominio público (Public Domain) o usa TCP Proxy si está disponible.
3. Conéctate usando el host y puerto proporcionado.

## 🩺 Healthcheck
El contenedor incluye un chequeo de salud automático que verifica si MySQL responde a `ping` cada 15 segundos.
