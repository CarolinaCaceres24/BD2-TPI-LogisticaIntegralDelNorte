# Trabajo Práctico Integrador - Base de Datos II

🧾 Sistema: Logística Integral del Norte S.A.

# 📋Descripción

Este repositorio contiene el desarrollo del Trabajo Práctico Integrador de la materia Base de Datos II.

El proyecto consiste en el diseño e implementación de una base de datos para la empresa ficticia **Logística Integral del Norte S.A.**, cuyo objetivo es administrar la información del personal de la organización.

La base de datos permite gestionar:

- Empleados
- Áreas
- Usuarios
- Roles
- Solicitudes de días libres
- Bonificaciones
- Sanciones

Además, se implementaron distintos objetos propios de SQL Server para automatizar procesos y mantener la integridad de la información.


## 🖥️ Tecnologías utilizadas

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- SQL (T-SQL)


# ⚙️ Componentes técnicos

## Tablas

- Areas
- Roles
- EstadosSolicitud
- Empleados
- Usuarios
- SolicitudDeDiasLibres
- Bonificaciones
- Sanciones

---

## Vistas

- VW_Empleados
- VW_HistorialSolicitudes
- VW_NovedadesPersonal

---

## Procedimientos almacenados

- SP_RegistrarSolicitud
- SP_RegistrarBonificacion
- SP_RegistrarSancion

---

## Triggers

- TR_DescontarDiasLibres
- TR_EmpleadoInactivo

---

# Ejecución

1. Abrir SQL Server Management Studio.
2. Ejecutar el archivo **ScriptSQL.sql**.
3. El script crea automáticamente la base de datos.
4. Se crean las tablas.
5. Se insertan los datos de ejemplo.
6. Se crean las vistas.
7. Se crean los procedimientos almacenados.
8. Se crean los triggers.
9. Finalmente se ejecutan las pruebas de funcionamiento.

---

# Funcionalidades

✔ Gestión de empleados.

✔ Administración de áreas y usuarios.

✔ Gestión de roles.

✔ Registro de solicitudes de días libres.

✔ Registro de bonificaciones.

✔ Registro de sanciones.

✔ Automatización mediante procedimientos almacenados.

✔ Automatización mediante triggers.

✔ Consultas simplificadas mediante vistas.

---

# Integrantes

• Cáceres, Carolina 

---
# Grupo 80
