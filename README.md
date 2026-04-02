# MySQL en Railway

Este repositorio contiene la configuración para desplegar un servidor MySQL optimizado en Railway.

# Deploy and Host

Puedes desplegar este proyecto directamente en Railway usando el siguiente botón o siguiendo los pasos manuales.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/mysql-en-railway)

## About Hosting

Este proyecto proporciona un contenedor Dockerizado para **MySQL 8.0**, preconfigurado para ejecutarse eficientemente en la infraestructura de Railway. Incluye ajustes específicos para permisos de volumen, zona horaria (Perú) y comprobaciones de estado (Healthchecks) para garantizar una alta disponibilidad.

## Why Deploy

- **Optimizado para Nube**: Configuración ajustada para entornos de contenedores efímeros pero con persistencia garantizada.
- **Zona Horaria Local**: Configurado por defecto con `America/Lima` para facilitar el manejo de fechas en aplicaciones locales.
- **Listo para Producción**: Incluye Healthchecks y gestión de usuarios root segura mediante variables de entorno.

## Common Use Cases

- **Backend para Aplicaciones Web**: Base de datos principal para aplicaciones Node.js, Python, Go, etc.
- **Microservicios**: Instancia de base de datos dedicada para servicios desacoplados.
- **Entornos de Desarrollo y Staging**: Réplica rápida de entornos de base de datos SQL.

## Dependencies for

### Deployment Dependencies

Para desplegar este proyecto necesitas:

- Una cuenta en [Railway](https://railway.app/).
- (Opcional) [Railway CLI](https://docs.railway.app/guides/cli) instalado para gestión avanzada.
- (Opcional) Cliente MySQL local (Workbench, DBeaver, TablePlus) para conexión remota.

---

## 🚀 Guía de Despliegue Manual

Si no usas el botón de "Deploy on Railway":

1. **Nuevo Proyecto**: En Railway, crea un `New Project` > `Empty Project`.
2. **Servicio**: Añade un servicio seleccionando este repositorio.
3. **Variables de Entorno**: Configura las siguientes variables **ANTES** del despliegue:

### Variables de Entorno

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `MYSQL_ROOT_PASSWORD` | **Requerido**. Contraseña para `root`. | `MiPasswordSeguro123!` |
| `MYSQL_DATABASE` | crea una DB al iniciar. | `mi_base_datos` |
| `MYSQL_USER` | Crea un usuario adicional. | `app_user` |
| `MYSQL_PASSWORD` | Contraseña para `MYSQL_USER`. | `AppPass123!` |

> **Nota**: `TZ` está configurado por defecto a `America/Lima` en el Dockerfile.

## 💾 Configuración de Volumen (Persistencia)

**CRÍTICO**: Para evitar perder datos al reiniciar, configura un volumen.

1. Ve a **Settings** > **Volumes** en tu servicio Railway.
2. Haz clic en **+ Add Volume**.
3. Ruta de montaje (`Mount Path`):

   ```text
   /var/lib/mysql
   ```

## 🛠️ Conexión

### Red Privada (Internal)

- **Host**: `${RAILWAY_PRIVATE_DOMAIN}`
- **Port**: `3306`

### Red Pública (External)

1. Ve a **Settings** > **Networking**.
2. Genera un **Public Domain**.
3. Usa el host y puerto TCP proporcionados (ej. `autorailway.com:12345`).

## 🩺 Healthcheck
El contenedor verifica automáticamente su estado cada 15s usando `mysqladmin ping`.
