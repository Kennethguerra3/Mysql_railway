# ==========================================
# 1. IMAGEN BASE
# ==========================================
# Usamos la versión 8.0 estable. Ojo: la imagen oficial actual (8.0.46) está basada
# en Oracle Linux 9, no en Debian, por eso más abajo se usa microdnf y no apt.
FROM mysql:8.0

# ==========================================
# 2. PERMISOS
# ==========================================
# MySQL oficial corre como usuario 'mysql' por defecto, pero para inicialización
# y permisos en volúmenes de Railway, a veces requerimos ajustes como root.
# Sin embargo, la imagen oficial maneja bien los volúmenes si se montan en /var/lib/mysql.
# Elevamos a root para asegurar creación de carpetas custom si fuera necesario.
USER root

# Instalar tzdata para configurar correctamente la zona horaria (base image es Oracle Linux/RHEL)
RUN microdnf install -y tzdata && microdnf clean all


# ==========================================
# 3. VARIABLES DE ENTORNO (CONFIGURACIÓN)
# ==========================================
# Zona Horaria (Perú)
ENV TZ=America/Lima

# Configuración por defecto para codificación
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# ==========================================
# 4. SISTEMA DE ARCHIVOS
# ==========================================
# Aseguramos que el directorio de datos tenga los permisos correctos.
# Railway monta el volumen persistente aquí.
RUN mkdir -p /var/lib/mysql \
    && chmod -R 777 /var/lib/mysql \
    && chown -R mysql:mysql /var/lib/mysql

# Directorio para logs si se desea configurar
RUN mkdir -p /var/log/mysql \
    && chmod -R 777 /var/log/mysql \
    && chown -R mysql:mysql /var/log/mysql

# ==========================================
# 5. HEALTHCHECK (MONITOREO)
# ==========================================
# Verifica cada 15s que el servidor responda.
# Usa mysqladmin ping. Se requiere password si se establece, pero para healthcheck interno
# podemos usar una configuración que permita ping o usar el usuario root con password.
# NOTA: En MySQL 8, 'ping' puede requerir autenticación.
# Usamos un healthcheck básico de TCP o mysqladmin con credenciales si están disponibles en ENV.
# Para simplicidad y robustez en el Dockerfile genérico:
HEALTHCHECK --interval=15s --timeout=5s --start-period=30s --retries=3 \
    CMD mysqladmin ping -h localhost -u root -p${MYSQL_ROOT_PASSWORD} || exit 1

# ==========================================
# 6. CONFIGURACIÓN FINAL
# ==========================================
# Copiamos configuración custom de rendimiento y memoria.
# Ruta verificada en producción: /etc/my.cnf de la imagen incluye /etc/mysql/conf.d,
# por lo que estos ajustes sí se aplican al arrancar.
# Importante: si el servicio en Railway tiene un "Custom Start Command" con opciones
# de mysqld (por ejemplo --innodb-buffer-pool-size), esas opciones ganan sobre este
# archivo, porque la línea de comandos tiene mayor prioridad que los ficheros .cnf.
COPY custom.cnf /etc/mysql/conf.d/

# ==========================================
# 7. ARRANQUE
# ==========================================
EXPOSE 3306

# Volvemos al usuario mysql para ejecución segura (recomendado), 
# aunque en algunos entornos de contenedores (como Railway) root funciona bien para evitar lios de permisos.
# La imagen oficial tiene un ENTRYPOINT que maneja el cambio de usuario.
# Dejamos que el ENTRYPOINT oficial haga su trabajo.
CMD ["mysqld"]
