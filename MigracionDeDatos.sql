--------------------------------------------------------------------------
----------CREACION DE STORED PROCEDURES PARA MIGRACION-------------------


BEGIN TRANSACTION
USE [GD2C2020]
GO

INSERT INTO UNIX.TipoMotor
SELECT DISTINCT TIPO_MOTOR_CODIGO
FROM gd_esquema.Maestra
WHERE TIPO_MOTOR_CODIGO IS NOT NULL;

INSERT INTO UNIX.TipoCaja
SELECT DISTINCT TIPO_CAJA_CODIGO, TIPO_CAJA_DESC
FROM gd_esquema.Maestra
WHERE TIPO_CAJA_CODIGO IS NOT NULL;

INSERT INTO UNIX.TipoAuto
SELECT DISTINCT TIPO_AUTO_CODIGO, TIPO_AUTO_DESC
FROM gd_esquema.Maestra
WHERE TIPO_AUTO_CODIGO IS NOT NULL;

INSERT INTO UNIX.TipoTransmision
SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC
FROM gd_esquema.Maestra
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL;

INSERT INTO UNIX.Cliente
	(CLIENTE_APELLIDO,CLIENTE_NOMBRE,CLIENTE_DIRECCION,CLIENTE_DNI, CLIENTE_FECHA_NAC,CLIENTE_MAIL)
SELECT DISTINCT CLIENTE_APELLIDO, CLIENTE_NOMBRE, CLIENTE_DIRECCION, CLIENTE_DNI, CLIENTE_FECHA_NAC, CLIENTE_MAIL
FROM gd_esquema.Maestra
WHERE CLIENTE_APELLIDO IS NOT NULL AND CLIENTE_DNI IS NOT NULL;

INSERT INTO UNIX.Cliente
	(CLIENTE_APELLIDO,CLIENTE_NOMBRE,CLIENTE_DIRECCION,CLIENTE_DNI, CLIENTE_FECHA_NAC,CLIENTE_MAIL)
SELECT DISTINCT FAC_CLIENTE_APELLIDO, FAC_CLIENTE_NOMBRE, FAC_CLIENTE_DIRECCION, FAC_CLIENTE_DNI, FAC_CLIENTE_FECHA_NAC, FAC_CLIENTE_MAIL
FROM gd_esquema.Maestra
WHERE FAC_CLIENTE_APELLIDO IS NOT NULL AND FAC_CLIENTE_DNI IS NOT NULL;

INSERT INTO UNIX.Fabricante
	(FABRICANTE_NOMBRE)
SELECT DISTINCT FABRICANTE_NOMBRE
FROM gd_esquema.Maestra;

INSERT INTO UNIX.Sucursal
	(SUCURSAL_DIRECCION, SUCURSAL_MAIL,SUCURSAL_TELEFONO, SUCURSAL_CIUDAD)
SELECT DISTINCT SUCURSAL_DIRECCION, SUCURSAL_MAIL, SUCURSAL_TELEFONO, SUCURSAL_CIUDAD
FROM gd_esquema.Maestra
WHERE SUCURSAL_DIRECCION IS NOT NULL;

INSERT INTO UNIX.Modelo
	(MODELO_CODIGO, MODELO_NOMBRE, MODELO_POTENCIA,TIPO_AUTO_CODIGO, TIPO_MOTOR_CODIGO, TIPO_CAJA_CODIGO, TIPO_TRANSMISION_CODIGO, FABRICANTE_CODIGO)
SELECT DISTINCT MODELO_CODIGO, MODELO_NOMBRE, MODELO_POTENCIA, TIPO_AUTO_CODIGO, TIPO_MOTOR_CODIGO, TIPO_CAJA_CODIGO, TIPO_TRANSMISION_CODIGO, F.FABRICANTE_CODIGO
FROM gd_esquema.Maestra M
	INNER JOIN UNIX.Fabricante F ON M.FABRICANTE_NOMBRE = F.FABRICANTE_NOMBRE
WHERE TIPO_AUTO_CODIGO IS NOT NULL AND TIPO_CAJA_CODIGO IS NOT NULL AND TIPO_MOTOR_CODIGO IS NOT NULL AND TIPO_TRANSMISION_CODIGO IS NOT NULL;

INSERT INTO UNIX.Automovil
	(MODELO_CODIGO, AUTO_CANT_KMS, AUTO_NRO_CHASIS, AUTO_FECHA_ALTA, AUTO_NRO_MOTOR, AUTO_PATENTE, SUCURSAL_CODIGO)
SELECT DISTINCT MODELO_CODIGO, AUTO_CANT_KMS, AUTO_NRO_CHASIS, AUTO_FECHA_ALTA, AUTO_NRO_MOTOR, AUTO_PATENTE, M.SUCURSAL_CODIGO
FROM gd_esquema.Maestra A
	INNER JOIN UNIX.Sucursal M ON A.SUCURSAL_DIRECCION = M.SUCURSAL_DIRECCION
WHERE AUTO_PATENTE IS NOT NULL
ORDER BY AUTO_PATENTE;

INSERT INTO UNIX.AutoParte
	(AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, FABRICANTE_CODIGO, MODELO_CODIGO, AUTO_PARTE_PRECIO)
SELECT DISTINCT AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, FABRICANTE_CODIGO, MODELO_CODIGO, COMPRA_PRECIO
FROM gd_esquema.Maestra M
	INNER JOIN UNIX.Fabricante F ON M.FABRICANTE_NOMBRE = F.FABRICANTE_NOMBRE
WHERE AUTO_PATENTE IS NULL AND AUTO_PARTE_CODIGO IS NOT NULL AND COMPRA_PRECIO IS NOT NULL;

INSERT INTO UNIX.Compra
	(COMPRA_NRO,CLIENTE_CODIGO, SUCURSAL_CODIGO, COMPRA_FECHA, TIPO_COMPRA, PRECIO_TOTAL)
SELECT COMPRA_NRO, Cl.CLIENTE_CODIGO, S.SUCURSAL_CODIGO, COMPRA_FECHA, 'AM', COMPRA_PRECIO
FROM
	(
	SELECT DISTINCT COMPRA_NRO, CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, SUCURSAL_DIRECCION, COMPRA_FECHA, COMPRA_PRECIO
	FROM gd_esquema.Maestra M
	WHERE 
		COMPRA_NRO IS NOT NULL AND
		CLIENTE_DNI IS NOT NULL AND
		AUTO_PATENTE IS NOT NULL		
	) AS M
	INNER JOIN UNIX.Sucursal S ON S.SUCURSAL_DIRECCION = M.SUCURSAL_DIRECCION
	INNER JOIN UNIX.Cliente Cl ON 
(
	Cl.CLIENTE_DNI = M.CLIENTE_DNI and
		Cl.CLIENTE_APELLIDO= M.CLIENTE_APELLIDO and
		Cl.CLIENTE_NOMBRE= M.CLIENTE_NOMBRE
)
ORDER BY COMPRA_NRO

INSERT INTO UNIX.CompraAutomovil (COMPRA_NRO, AUTOMOVIL_CODIGO, COMPRA_PRECIO)
SELECT COMPRA_NRO, A.AUTOMOVIL_CODIGO, COMPRA_PRECIO
FROM (
	SELECT DISTINCT COMPRA_NRO, AUTO_PATENTE, COMPRA_PRECIO FROM gd_esquema.Maestra
	WHERE 
		COMPRA_NRO IS NOT NULL AND
		AUTO_PATENTE IS NOT NULL) AS M
LEFT JOIN UNIX.Automovil A ON (M.AUTO_PATENTE = A.AUTO_PATENTE);

COMMIT


-- ------------------------------------------------------------------------------------
-- IF(OBJECT_ID('UNIX.Migrador_Fabricante') IS NOT NULL)
-- 	DROP PROCEDURE UNIX.Migrador_Fabricante

-- GO
-- CREATE PROCEDURE UNIX.Migrador_Fabricante
-- AS
-- BEGIN
-- 	INSERT INTO UNIX.Fabricante
-- 	SELECT DISTINCT FABRICANTE_NOMBRE
-- 	FROM gd_esquema.Maestra;
-- END
-- GO

-- BEGIN

-- 	EXEC UNIX.Migrador_Fabricante

-- END
-- GO
