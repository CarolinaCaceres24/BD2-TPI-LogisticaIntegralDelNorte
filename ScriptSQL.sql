USE master;
GO

IF DB_ID('LogisticaIntegralDelNorte') IS NOT NULL
BEGIN
ALTER DATABASE LogisticaIntegralDelNorte SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE LogisticaIntegralDelNorte;
END
GO

CREATE DATABASE LogisticaIntegralDelNorte;
GO

USE LogisticaIntegralDelNorte;
GO


CREATE TABLE Areas
(
IDArea INT IDENTITY(1,1) PRIMARY KEY,
Nombre VARCHAR(50) NOT NULL UNIQUE
);
GO




CREATE TABLE Roles
(
IDRol INT IDENTITY(1,1) PRIMARY KEY,
Nombre VARCHAR(50) NOT NULL UNIQUE
);
GO



CREATE TABLE EstadosSolicitud
(
IDEstado INT IDENTITY(1,1) PRIMARY KEY,
NombreEstado VARCHAR(30) NOT NULL UNIQUE
);
GO


CREATE TABLE Empleados
(
IDEmpleado INT IDENTITY(1,1) PRIMARY KEY,

Nombre VARCHAR(50) NOT NULL,  

Apellido VARCHAR(50) NOT NULL,  

Legajo VARCHAR(20) NOT NULL UNIQUE,  

IDArea INT NOT NULL,  

Mail VARCHAR(100),  

Direccion VARCHAR(150),  

Telefono VARCHAR(30),  

CantidadDiasLibres INT NOT NULL  
    CONSTRAINT DF_Empleados_Dias DEFAULT(14),  

Activo BIT NOT NULL  
    CONSTRAINT DF_Empleados_Activo DEFAULT(1),  

FechaBaja DATE NULL,  

CONSTRAINT FK_Empleados_Areas  
    FOREIGN KEY(IDArea)  
    REFERENCES Areas(IDArea),  

CONSTRAINT CHK_Empleados_Dias  
    CHECK(CantidadDiasLibres>=0)

);
GO


CREATE TABLE Usuarios
(
IDUsuario INT IDENTITY(1,1) PRIMARY KEY,

Username VARCHAR(50) NOT NULL UNIQUE,  

Contrasena VARCHAR(255) NOT NULL,  

IDRol INT NOT NULL,  

IDEmpleado INT NULL UNIQUE,  

FechaAlta DATE NOT NULL  
    CONSTRAINT DF_Usuarios_FechaAlta DEFAULT(GETDATE()),  

FechaBaja DATE NULL,  

Activo BIT NOT NULL  
    CONSTRAINT DF_Usuarios_Activo DEFAULT(1),  

CONSTRAINT FK_Usuarios_Roles  
    FOREIGN KEY(IDRol)  
    REFERENCES Roles(IDRol),  

CONSTRAINT FK_Usuarios_Empleados  
    FOREIGN KEY(IDEmpleado)  
    REFERENCES Empleados(IDEmpleado),  

CONSTRAINT CHK_Usuarios_Fechas  
    CHECK(FechaBaja IS NULL OR FechaBaja>=FechaAlta)

);
GO



CREATE TABLE SolicitudDeDiasLibres
(
IDSolicitud INT IDENTITY(1,1) PRIMARY KEY,

IDEmpleado INT NOT NULL,  

FechaSolicitud DATE NOT NULL  
    CONSTRAINT DF_Solicitudes_Fecha DEFAULT(GETDATE()),  

FechaInicio DATE NOT NULL,  

CantidadDias INT NOT NULL,  

IDEstado INT NOT NULL  
    CONSTRAINT DF_Solicitudes_Estado DEFAULT(1),  

IDUsuarioDictamen INT NULL,  

CONSTRAINT FK_Solicitudes_Empleado  
    FOREIGN KEY(IDEmpleado)  
    REFERENCES Empleados(IDEmpleado),  

CONSTRAINT FK_Solicitudes_Estado  
    FOREIGN KEY(IDEstado)  
    REFERENCES EstadosSolicitud(IDEstado),  

CONSTRAINT FK_Solicitudes_Usuario  
    FOREIGN KEY(IDUsuarioDictamen)  
    REFERENCES Usuarios(IDUsuario),  

CONSTRAINT CHK_Solicitudes_Dias  
    CHECK(CantidadDias>0),  

CONSTRAINT CHK_Solicitudes_Fechas  
    CHECK(FechaInicio>=FechaSolicitud)

);
GO


CREATE TABLE Bonificaciones
(
IDBonificacion INT IDENTITY(1,1) PRIMARY KEY,

IDEmpleado INT NOT NULL,  

IDUsuarioDictamen INT NOT NULL,  

FechaBonificacion DATE NOT NULL  
    CONSTRAINT DF_Bonificaciones_Fecha DEFAULT(GETDATE()),  

Motivo VARCHAR(150) NOT NULL,  

Monto DECIMAL(10,2) NOT NULL,  

CONSTRAINT FK_Bonificaciones_Empleado  
    FOREIGN KEY(IDEmpleado)  
    REFERENCES Empleados(IDEmpleado),  

CONSTRAINT FK_Bonificaciones_Usuario  
    FOREIGN KEY(IDUsuarioDictamen)  
    REFERENCES Usuarios(IDUsuario),  

CONSTRAINT CHK_Bonificaciones_Monto  
    CHECK(Monto>0)

);
GO


CREATE TABLE Sanciones
(
IDSancion INT IDENTITY(1,1) PRIMARY KEY,

IDEmpleado INT NOT NULL,  

IDUsuarioDictamen INT NOT NULL,  

FechaSancion DATE NOT NULL  
    CONSTRAINT DF_Sanciones_Fecha DEFAULT(GETDATE()),  

Motivo VARCHAR(150) NOT NULL,  

DiasSuspension INT NOT NULL,  

CONSTRAINT FK_Sanciones_Empleado  
    FOREIGN KEY(IDEmpleado)  
    REFERENCES Empleados(IDEmpleado),  

CONSTRAINT FK_Sanciones_Usuario  
    FOREIGN KEY(IDUsuarioDictamen)  
    REFERENCES Usuarios(IDUsuario),  

CONSTRAINT CHK_Sanciones_Dias  
    CHECK(DiasSuspension>=0)

);
GO


INSERT INTO Areas (Nombre)
VALUES
('Recursos Humanos'),
('Administración'),
('Distribución'),
('Depósito');



INSERT INTO Roles (Nombre)
VALUES
('Administrador'),
('Empleado');

-- ESTADOS DE SOLICITUD

INSERT INTO EstadosSolicitud (NombreEstado)
VALUES
('Pendiente'),
('Aprobada'),
('Rechazada');

-- EMPLEADOS

INSERT INTO Empleados
(
Nombre,
Apellido,
Legajo,
IDArea,
Mail,
Direccion,
Telefono
)
VALUES
('Laura','Gómez','EMP001',1,'laura.gomez@lin.com','Av. San Martín 120','1122334455'),
('Carlos','Pérez','EMP002',3,'carlos.perez@lin.com','Belgrano 450','1133445566'),
('María','López','EMP003',4,'maria.lopez@lin.com','Rivadavia 820','1144556677'),
('Javier','Sosa','EMP004',3,'javier.sosa@lin.com','Mitre 320','1155667788'),
('Ana','Martínez','EMP005',2,'ana.martinez@lin.com','Moreno 150','1166778899'),
('Pedro','Fernández','EMP006',4,'pedro.fernandez@lin.com','Lavalle 998','1177889900');


-- USUARIOS

INSERT INTO Usuarios
(
Username,
Contrasena,
IDRol,
IDEmpleado
)
VALUES
('lgomez','Admin123',1,1),
('cperez','Empleado123',2,2),
('mlopez','Empleado123',2,3),
('jsosa','Empleado123',2,4),
('amartinez','Empleado123',2,5),
('pfernandez','Empleado123',2,6);

-- SOLICITUDES DE DÍAS LIBRES

INSERT INTO SolicitudDeDiasLibres
(
IDEmpleado,
FechaSolicitud,
FechaInicio,
CantidadDias,
IDEstado,
IDUsuarioDictamen
)
VALUES
(2,'2026-06-27','2026-07-10',3,1,NULL),
(3,'2026-06-28','2026-07-15',5,2,1),
(4,'2026-06-29','2026-08-01',2,3,1),
(5,'2026-06-30','2026-08-12',4,2,1);



-- BONIFICACIONES

INSERT INTO Bonificaciones
(
IDEmpleado,
IDUsuarioDictamen,
Motivo,
Monto
)
VALUES
(2,1,'Premio por productividad',50000),
(3,1,'Presentismo',30000),
(4,1,'Cumplimiento de rutas',45000),
(5,1,'Desempeño destacado',35000);

-- SANCIONES

INSERT INTO Sanciones
(
IDEmpleado,
IDUsuarioDictamen,
Motivo,
DiasSuspension
)
VALUES
(4,1,'Demora en una entrega',2),
(6,1,'Ausencia injustificada',1);

-- CONSULTAS DE VERIFICACIÓN

SELECT * FROM Areas;
SELECT * FROM Roles;
SELECT * FROM EstadosSolicitud;
SELECT * FROM Empleados;
SELECT * FROM Usuarios;
SELECT * FROM SolicitudDeDiasLibres;
SELECT * FROM Bonificaciones;
SELECT * FROM Sanciones;
GO

CREATE VIEW VW_Empleados
AS
SELECT
    E.IDEmpleado,
    E.Legajo,
    E.Nombre,
    E.Apellido,
    A.Nombre AS Area,
    E.Mail,
    E.Telefono,
    E.CantidadDiasLibres,
    E.Activo
FROM Empleados E
INNER JOIN Areas A
    ON E.IDArea = A.IDArea;
GO

CREATE VIEW VW_HistorialSolicitudes
AS
SELECT
    S.IDSolicitud,
    E.Legajo,
    E.Nombre + ' ' + E.Apellido AS Empleado,
    S.FechaSolicitud,
    S.FechaInicio,
    S.CantidadDias,
    ES.NombreEstado,
    U.Username AS UsuarioDictamen
FROM SolicitudDeDiasLibres S
INNER JOIN Empleados E
    ON S.IDEmpleado = E.IDEmpleado
INNER JOIN EstadosSolicitud ES
    ON S.IDEstado = ES.IDEstado
LEFT JOIN Usuarios U
    ON S.IDUsuarioDictamen = U.IDUsuario;
GO

CREATE VIEW VW_NovedadesPersonal
AS

SELECT
    E.Legajo,
    E.Nombre + ' ' + E.Apellido AS Empleado,
    'Bonificación' AS Tipo,
    B.FechaBonificacion AS Fecha,
    B.Motivo,
    CAST(B.Monto AS DECIMAL(10,2)) AS Valor
FROM Bonificaciones B
INNER JOIN Empleados E
    ON B.IDEmpleado = E.IDEmpleado

UNION ALL

SELECT
    E.Legajo,
    E.Nombre + ' ' + E.Apellido AS Empleado,
    'Sanción' AS Tipo,
    S.FechaSancion,
    S.Motivo,
    CAST(S.DiasSuspension AS DECIMAL(10,2))
FROM Sanciones S
INNER JOIN Empleados E
    ON S.IDEmpleado = E.IDEmpleado;
GO

SELECT * FROM VW_Empleados;
GO

SELECT * FROM VW_HistorialSolicitudes;
GO

SELECT * FROM VW_NovedadesPersonal;
GO

CREATE PROCEDURE SP_RegistrarSolicitud
(
    @IDEmpleado INT,
    @FechaInicio DATE,
    @CantidadDias INT
)
AS
BEGIN

    INSERT INTO SolicitudDeDiasLibres
    (
        IDEmpleado,
        FechaSolicitud,
        FechaInicio,
        CantidadDias,
        IDEstado,
        IDUsuarioDictamen
    )
    VALUES
    (
        @IDEmpleado,
        GETDATE(),
        @FechaInicio,
        @CantidadDias,
        1,
        NULL
    );

END;
GO


CREATE PROCEDURE SP_RegistrarBonificacion
(
    @IDEmpleado INT,
    @IDUsuarioDictamen INT,
    @Motivo VARCHAR(150),
    @Monto DECIMAL(10,2)
)
AS
BEGIN

    INSERT INTO Bonificaciones
    (
        IDEmpleado,
        IDUsuarioDictamen,
        Motivo,
        Monto
    )
    VALUES
    (
        @IDEmpleado,
        @IDUsuarioDictamen,
        @Motivo,
        @Monto
    );

END;
GO

CREATE PROCEDURE SP_RegistrarSancion
(
    @IDEmpleado INT,
    @IDUsuarioDictamen INT,
    @Motivo VARCHAR(150),
    @DiasSuspension INT
)
AS
BEGIN

    INSERT INTO Sanciones
    (
        IDEmpleado,
        IDUsuarioDictamen,
        Motivo,
        DiasSuspension
    )
    VALUES
    (
        @IDEmpleado,
        @IDUsuarioDictamen,
        @Motivo,
        @DiasSuspension
    );

END;
GO


EXEC SP_RegistrarSolicitud
2,
'2026-09-15',
2;
GO

EXEC SP_RegistrarBonificacion
2,
1,
'Reconocimiento por desempeño',
25000;
GO

EXEC SP_RegistrarSancion
6,
1,
'Llegadas reiteradas fuera de horario',
1;
GO

SELECT * FROM SolicitudDeDiasLibres;
SELECT * FROM Bonificaciones;
SELECT * FROM Sanciones;
GO


CREATE TRIGGER TR_DescontarDiasLibres
ON SolicitudDeDiasLibres
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        INNER JOIN deleted d
            ON i.IDSolicitud = d.IDSolicitud
        WHERE i.IDEstado = 2
          AND d.IDEstado <> 2
    )
    BEGIN

        UPDATE E
        SET CantidadDiasLibres = E.CantidadDiasLibres - i.CantidadDias
        FROM Empleados E
        INNER JOIN inserted i
            ON E.IDEmpleado = i.IDEmpleado;

    END
END;
GO


CREATE TRIGGER TR_EmpleadoInactivo
ON SolicitudDeDiasLibres
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Empleados e ON i.IDEmpleado = e.IDEmpleado
        WHERE e.Activo = 0 OR e.FechaBaja IS NOT NULL
    )
    BEGIN
        RAISERROR('No se pueden registrar solicitudes para empleados inactivos.', 16, 1);
        RETURN; 
    END

    
    INSERT INTO SolicitudDeDiasLibres
    (
        IDEmpleado,
        FechaSolicitud,
        FechaInicio,
        CantidadDias,
        IDEstado,
        IDUsuarioDictamen
    )
    SELECT
        IDEmpleado,
        FechaSolicitud,
        FechaInicio,
        CantidadDias,
        IDEstado,
        IDUsuarioDictamen
    FROM inserted;
END;
GO




UPDATE SolicitudDeDiasLibres
SET IDEstado = 2
WHERE IDSolicitud = 1;
GO

SELECT * FROM Empleados;
GO



UPDATE Empleados
SET Activo = 0,
    FechaBaja = GETDATE()
WHERE IDEmpleado = 6;
GO

INSERT INTO SolicitudDeDiasLibres
(
    IDEmpleado,
    FechaSolicitud,
    FechaInicio,
    CantidadDias,
    IDEstado
)
VALUES
(
    6,
    GETDATE(),
    '2026-10-10',
    2,
    1
);
GO