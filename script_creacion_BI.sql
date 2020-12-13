USE [GD2C2020]
GO

---------------------------------------------------------  CREACION DE TABLAS  ------------------------------------------------------
BEGIN TRANSACTION

-------------------------  TABLAS HECHOS -------------------------------

CREATE TABLE UNIX.BI_HechoModelo
(
  MODELO_CODIGO DECIMAL(18,0) NOT NULL,
  TIPO_CAJA_CODIGO decimal(18,0) NOT NULL,
  TIPO_MOTOR_CODIGO decimal(18,0),
  TIPO_TRANSMISION_CODIGO decimal(18,0) NOT NULL,
  TIPO_AUTO_CODIGO decimal(18,0) NOT NULL,
  FABRICANTE_CODIGO INT NOT NULL,
  POTENCIA_CODIGO INT NOT NULL,
  PROMEDIO_TIEMPO_STOCK INT,
  PRIMARY KEY
  (
    MODELO_CODIGO, TIPO_CAJA_CODIGO, TIPO_MOTOR_CODIGO, TIPO_TRANSMISION_CODIGO,
    TIPO_AUTO_CODIGO, FABRICANTE_CODIGO, POTENCIA_CODIGO
  )
);

CREATE TABLE UNIX.BI_HechoAutomovilCompra
(
  TIEMPO_CODIGO INT NOT NULL,
  SUCURSAL_CODIGO INT,
  CLIENTE_EDAD_CODIGO INT NOT NULL,
	CANTIDAD_TOTAL_COMPRADA INT NOT NULL,
	COMPRA_TOTAL DECIMAL(18,2) NOT NULL,
  PRIMARY KEY(TIEMPO_CODIGO,SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO)
)

CREATE TABLE UNIX.BI_HechoAutomovilVenta
(
  TIEMPO_CODIGO INT NOT NULL,
  SUCURSAL_CODIGO INT,
  CLIENTE_EDAD_CODIGO INT NOT NULL,
	CANTIDAD_TOTAL_VENDIDA INT NOT NULL,
	VENTA_TOTAL DECIMAL(18,2) NOT NULL,
  PRIMARY KEY(TIEMPO_CODIGO,SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO)
)

CREATE TABLE UNIX.BI_HechoAutoparteVenta
(
  TIEMPO_CODIGO INT NOT NULL,
  SUCURSAL_CODIGO INT NOT NULL,
  AUTO_PARTE_CODIGO DECIMAL(18,0) NOT NULL,
  CLIENTE_EDAD_CODIGO INT NOT NULL,
  CANTIDAD_TOTAL_VENDIDA INT NOT NULL,
  VENTA_TOTAL decimal(18,0) NOT NULL,
  PRIMARY KEY(TIEMPO_CODIGO, SUCURSAL_CODIGO, AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO)
)

CREATE TABLE UNIX.BI_HechoAutoparteCompra
(
  TIEMPO_CODIGO INT NOT NULL,
  SUCURSAL_CODIGO INT NOT NULL,
  AUTO_PARTE_CODIGO DECIMAL(18,0) NOT NULL,
  CLIENTE_EDAD_CODIGO INT NOT NULL,
  CANTIDAD_TOTAL_COMPRADA INT NOT NULL,
  COMPRA_TOTAL decimal(18,0) NOT NULL,
  PRIMARY KEY(TIEMPO_CODIGO, SUCURSAL_CODIGO, AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO)
);


------------------------- TABLAS DIMENSIONES -------------------------------

CREATE TABLE UNIX.BI_Modelo
(
  MODELO_CODIGO DECIMAL(18,0) PRIMARY KEY,
  MODELO_NOMBRE nvarchar(255)
);

CREATE TABLE UNIX.BI_TipoCaja
(
  TIPO_CAJA_CODIGO decimal(18,0) PRIMARY KEY,
  TIPO_CAJA_DESC nvarchar(255)
);

CREATE TABLE UNIX.BI_TipoMotor
(
  TIPO_MOTOR_CODIGO decimal(18,0) PRIMARY KEY
);

CREATE TABLE UNIX.BI_Potencia
(
  POTENCIA_CODIGO INT NOT NULL,
  POTENCIA NVARCHAR(255) NOT NULL,
  PRIMARY KEY(POTENCIA_CODIGO)
)

CREATE TABLE UNIX.BI_Fabricante
(
  FABRICANTE_CODIGO INT NOT NULL,
  FABRICANTE_NOMBRE NVARCHAR(255) NOT NULL,
  PRIMARY KEY(FABRICANTE_CODIGO)
)

CREATE TABLE UNIX.BI_TipoAuto
(
  TIPO_AUTO_CODIGO DECIMAL(18,0) NOT NULL,
  TIPO_AUTO_DESC NVARCHAR(255) NOT NULL,
  PRIMARY KEY(TIPO_AUTO_CODIGO)
)

CREATE TABLE UNIX.BI_TipoTransmision
(
  TIPO_TRANSMISION_CODIGO DECIMAL(18,0) NOT NULL,
  TIPO_TRANSMISION_DESC NVARCHAR(255) NOT NULL,
  PRIMARY KEY (TIPO_TRANSMISION_CODIGO)
)

CREATE TABLE UNIX.BI_Autoparte(
  AUTO_PARTE_CODIGO DECIMAL(18,0) NOT NULL,
  AUTO_PARTE_DESCRIPCION NVARCHAR(255) NOT NULL,
  AUTO_PARTE_PRECIO DECIMAL(18,2) NOT NULL,
  PRIMARY KEY (AUTO_PARTE_CODIGO)
)

CREATE TABLE UNIX.BI_Sucursal
(
  SUCURSAL_CODIGO INT PRIMARY KEY,
  SUCURSAL_DIRECCION nvarchar(255) NOT NULL,
  SUCURSAL_MAIL nvarchar(255) NOT NULL,
  SUCURSAL_TELEFONO decimal(18,0) NOT NULL,
  SUCURSAL_CIUDAD nvarchar(255) NOT NULL
);

CREATE TABLE UNIX.BI_Tiempo
(
  TIEMPO_CODIGO INT identity(1,1) PRIMARY KEY,
  MES INT NOT NULL,
  ANIO INT NOT NULL
);

CREATE TABLE UNIX.BI_Edad
(
  EDAD_CODIGO INT NOT NULL,
  EDAD NVARCHAR(255) NOT NULL
  PRIMARY KEY(EDAD_CODIGO)
)

COMMIT TRANSACTION


---------------------------------------------------------  CONSTRAINTS  ------------------------------------------------------

BEGIN TRANSACTION

------------------------- FOREING KEYS HECHO MODELO  ----------------------------

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_Modelo
FOREIGN KEY (MODELO_CODIGO) REFERENCES UNIX.BI_Modelo(MODELO_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_Fabricante
FOREIGN KEY (FABRICANTE_CODIGO) REFERENCES UNIX.BI_Fabricante(FABRICANTE_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_TipoCaja
FOREIGN KEY (TIPO_CAJA_CODIGO) REFERENCES UNIX.BI_TipoCaja(TIPO_CAJA_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_TipoMotor
FOREIGN KEY (TIPO_MOTOR_CODIGO) REFERENCES UNIX.BI_TipoMotor(TIPO_MOTOR_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_TipoTransmision
FOREIGN KEY (TIPO_TRANSMISION_CODIGO) REFERENCES UNIX.BI_TipoTransmision(TIPO_TRANSMISION_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_TipoAuto
FOREIGN KEY (TIPO_AUTO_CODIGO) REFERENCES UNIX.BI_TipoAuto(TIPO_AUTO_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_Potencia
FOREIGN KEY (POTENCIA_CODIGO) REFERENCES UNIX.BI_Potencia(POTENCIA_CODIGO);

------------------------- FOREING KEYS HECHO AUTOMOVIL COMPRA  ----------------------------

ALTER TABLE UNIX.BI_HechoAutomovilCompra
ADD CONSTRAINT FK_BI_HechoAutomovilCompra_Tiempo
FOREIGN KEY (TIEMPO_CODIGO) REFERENCES UNIX.BI_Tiempo(TIEMPO_CODIGO);

ALTER TABLE UNIX.BI_HechoAutomovilCompra
ADD CONSTRAINT FK_BI_HechoAutomovilCompra_Sucursal
FOREIGN KEY (SUCURSAL_CODIGO) REFERENCES UNIX.BI_Sucursal(SUCURSAL_CODIGO);

ALTER TABLE UNIX.BI_HechoAutomovilCompra
ADD CONSTRAINT FK_BI_HechoAutomovilCompra_Edad
FOREIGN KEY (CLIENTE_EDAD_CODIGO) REFERENCES UNIX.BI_Edad(EDAD_CODIGO);

------------------------- FOREING KEYS HECHO AUTOMOVIL VENTA  ----------------------------

ALTER TABLE UNIX.BI_HechoAutomovilVenta
ADD CONSTRAINT FK_BI_HechoAutomovilVenta_Tiempo
FOREIGN KEY (TIEMPO_CODIGO) REFERENCES UNIX.BI_Tiempo(TIEMPO_CODIGO);

ALTER TABLE UNIX.BI_HechoAutomovilVenta
ADD CONSTRAINT FK_BI_HechoAutomovilVenta_Sucursal
FOREIGN KEY (SUCURSAL_CODIGO) REFERENCES UNIX.BI_Sucursal(SUCURSAL_CODIGO);

ALTER TABLE UNIX.BI_HechoAutomovilVenta
ADD CONSTRAINT FK_BI_HechoAutomovilVenta_Edad
FOREIGN KEY (CLIENTE_EDAD_CODIGO) REFERENCES UNIX.BI_Edad(EDAD_CODIGO);
------------------------- FOREING KEYS HECHO AUTOPARTE VENTA  ----------------------------


ALTER TABLE UNIX.BI_HechoAutoParteVenta
ADD CONSTRAINT FK_Tiempo_AutoParte_Venta
FOREIGN KEY (TIEMPO_CODIGO) REFERENCES UNIX.BI_Tiempo(TIEMPO_CODIGO);

ALTER TABLE UNIX.BI_HechoAutoParteVenta
ADD CONSTRAINT FK_Autoparte_AutoParte_Venta
FOREIGN KEY (AUTO_PARTE_CODIGO) REFERENCES UNIX.BI_Autoparte(AUTO_PARTE_CODIGO);

ALTER TABLE UNIX.BI_HechoAutoParteVenta
ADD CONSTRAINT FK_Sucursal_AutoParte_Venta
FOREIGN KEY (SUCURSAL_CODIGO) REFERENCES UNIX.BI_Sucursal(SUCURSAL_CODIGO);

ALTER TABLE UNIX.BI_HechoAutoParteVenta
ADD CONSTRAINT FK_Edad_AutoParte_Venta
FOREIGN KEY (CLIENTE_EDAD_CODIGO) REFERENCES UNIX.BI_Edad(EDAD_CODIGO);

------------------------- FOREING KEYS HECHO AUTOPARTE COMPRA  ----------------------------

ALTER TABLE UNIX.BI_HechoAutoParteCompra
ADD CONSTRAINT FK_Tiempo_AutoParte_Compra
FOREIGN KEY (TIEMPO_CODIGO) REFERENCES UNIX.BI_Tiempo(TIEMPO_CODIGO);

ALTER TABLE UNIX.BI_HechoAutoParteCompra
ADD CONSTRAINT FK_Autoparte_AutoParte_Compra
FOREIGN KEY (AUTO_PARTE_CODIGO) REFERENCES UNIX.BI_Autoparte(AUTO_PARTE_CODIGO);

ALTER TABLE UNIX.BI_HechoAutoParteCompra
ADD CONSTRAINT FK_Sucursal_AutoParte_Compra
FOREIGN KEY (SUCURSAL_CODIGO) REFERENCES UNIX.BI_Sucursal(SUCURSAL_CODIGO);

ALTER TABLE UNIX.BI_HechoAutoParteCompra
ADD CONSTRAINT FK_Edad_AutoParte_Compra
FOREIGN KEY (CLIENTE_EDAD_CODIGO) REFERENCES UNIX.BI_Edad(EDAD_CODIGO);

COMMIT TRANSACTION


---------------------------------------------------------  INSERTS  ------------------------------------------------------

BEGIN TRANSACTION

------------------------- DIMENSIONES  ------------------------------------------

INSERT INTO UNIX.BI_Modelo(MODELO_CODIGO, MODELO_NOMBRE)
SELECT DISTINCT MODELO_CODIGO, MODELO_NOMBRE
FROM UNIX.Modelo
WHERE MODELO_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_TipoCaja (TIPO_CAJA_CODIGO, TIPO_CAJA_DESC)
SELECT DISTINCT TIPO_CAJA_CODIGO, TIPO_CAJA_DESC
FROM UNIX.TipoCaja
WHERE TIPO_CAJA_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_TipoMotor (TIPO_MOTOR_CODIGO)
SELECT DISTINCT TIPO_MOTOR_CODIGO
FROM UNIX.TipoMotor
WHERE TIPO_MOTOR_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_Fabricante (FABRICANTE_CODIGO, FABRICANTE_NOMBRE)
SELECT DISTINCT FABRICANTE_CODIGO, FABRICANTE_NOMBRE
FROM UNIX.Fabricante
WHERE FABRICANTE_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_TipoAuto (TIPO_AUTO_CODIGO, TIPO_AUTO_DESC)
SELECT DISTINCT TIPO_AUTO_CODIGO, TIPO_AUTO_DESC
FROM UNIX.TipoAuto
WHERE TIPO_AUTO_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_TipoTransmision (TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC)
SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC
FROM UNIX.TipoTransmision
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_Potencia(POTENCIA_CODIGO, POTENCIA)
VALUES(1, '50-150cv'), (2, '151-300cv'), (3, '> 300cv');

INSERT INTO UNIX.BI_Sucursal(SUCURSAL_CODIGO, SUCURSAL_DIRECCION, SUCURSAL_MAIL, SUCURSAL_TELEFONO,SUCURSAL_CIUDAD)
SELECT SUCURSAL_CODIGO, SUCURSAL_DIRECCION, SUCURSAL_MAIL, SUCURSAL_TELEFONO,SUCURSAL_CIUDAD
FROM UNIX.Sucursal

INSERT INTO UNIX.BI_Tiempo(ANIO,MES)
	(SELECT DISTINCT YEAR(COMPRA_FECHA), MONTH(COMPRA_FECHA) FROM UNIX.Compra)
	UNION
	(SELECT DISTINCT YEAR(FACTURA_FECHA), MONTH(FACTURA_FECHA) FROM UNIX.Factura)

INSERT INTO UNIX.BI_Edad (EDAD_CODIGO, EDAD)
VALUES(1, '18 - 30 anios'), (2, '30 - 50 anios'), (3, '> 50 anios');

INSERT INTO UNIX.BI_Autoparte(AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION,AUTO_PARTE_PRECIO)
SELECT AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION,AUTO_PARTE_PRECIO
FROM UNIX.Autoparte

------------------------- HECHO MODELO  ------------------------------------------

IF(OBJECT_ID('tempdb.dbo.#TablaTemporal') IS NOT NULL)
	DROP TABLE #TablaTemporal
GO

CREATE TABLE #TablaTemporal (MODELO_CODIGO int, tiempoStockPromedio int)

INSERT INTO #TablaTemporal
SELECT MODELO_CODIGO, SUM(DATEDIFF (DAY, COMPRA_FECHA , FACTURA_FECHA ))/ COUNT(*) tiempoStockPromedio
FROM UNIX.Automovil a
JOIN UNIX.CompraAutomovil ca ON (ca.AUTOMOVIL_CODIGO = a.AUTOMOVIL_CODIGO)
JOIN UNIX.Compra c ON (c.COMPRA_NRO  = ca.COMPRA_NRO)
JOIN UNIX.ItemAutomovil ia ON (ia.AUTOMOVIL_CODIGO = a.AUTOMOVIL_CODIGO)
JOIN UNIX.Factura f ON (f.FACTURA_NRO = ia.FACTURA_NRO)
GROUP BY MODELO_CODIGO
ORDER BY MODELO_CODIGO


INSERT INTO UNIX.BI_HechoModelo 
(MODELO_CODIGO, TIPO_CAJA_CODIGO, TIPO_MOTOR_CODIGO, TIPO_TRANSMISION_CODIGO,
 TIPO_AUTO_CODIGO, FABRICANTE_CODIGO, POTENCIA_CODIGO, PROMEDIO_TIEMPO_STOCK)
SELECT m.MODELO_CODIGO, TIPO_CAJA_CODIGO, TIPO_MOTOR_CODIGO, TIPO_TRANSMISION_CODIGO, TIPO_AUTO_CODIGO, FABRICANTE_CODIGO,
  CASE
    WHEN MODELO_POTENCIA BETWEEN 49 AND 150  THEN 1
    WHEN MODELO_POTENCIA BETWEEN 151 AND 300  THEN 2
    ELSE  3
  END AS POTENCIA_CODIGO, tiempoStockPromedio
FROM UNIX.Modelo m
JOIN #TablaTemporal t ON (t.MODELO_CODIGO = m.MODELO_CODIGO);
GO


--------------------------- FUNCION CALCULAR RANGO EDAD -----------------------------


CREATE OR ALTER FUNCTION CalcularRangoEdad(@FechaNacimiento DATETIME2)
RETURNS INT
BEGIN
  DECLARE @Anios INT
  DECLARE @Result INT
  SET @Anios = CAST(DATEDIFF (YEAR, @FechaNacimiento, GETDATE()) AS INT)
  
  IF (@Anios BETWEEN 18 AND 30) 
  BEGIN
    SET @Result = 1
  END

  IF (@Anios BETWEEN 31 AND 50) 
  BEGIN
    SET @Result = 2
  END

  IF (@Anios > 50) 
  BEGIN
    SET @Result = 3
  END

  RETURN @Result
END
GO

------------------------- HECHO AUTOMOVIL COMPRA  ------------------------------------------

INSERT INTO UNIX.BI_HechoAutomovilCompra (TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO, CANTIDAD_TOTAL_COMPRADA, COMPRA_TOTAL)
SELECT
  TIEMPO_CODIGO, s.SUCURSAL_CODIGO,
  dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC) CLIENTE_EDAD_CODIGO,
  COUNT(*) CANTIDAD_TOTAL_COMPRADA, SUM(PRECIO_TOTAL) COMPRA_TOTAL
FROM UNIX.Compra c
JOIN UNIX.BI_Tiempo t ON (t.ANIO =  YEAR(COMPRA_FECHA) AND t.MES = MONTH(COMPRA_FECHA))
JOIN UNIX.BI_Sucursal s ON (s.SUCURSAL_CODIGO = c.SUCURSAL_CODIGO)
JOIN UNIX.Cliente cl ON (cl.CLIENTE_CODIGO = c.CLIENTE_CODIGO)
WHERE TIPO_COMPRA = 'AM'
GROUP BY TIEMPO_CODIGO, s.SUCURSAL_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC)
ORDER BY TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO;


--------------------------- HECHO AUTOMOVIL VENTA -----------------------------

INSERT INTO UNIX.BI_HechoAutomovilVenta (TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO, CANTIDAD_TOTAL_VENDIDA, VENTA_TOTAL)
SELECT
  TIEMPO_CODIGO,
  s.SUCURSAL_CODIGO,
  dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC) CLIENTE_EDAD_CODIGO,
  COUNT(*) CANTIDAD_TOTAL_VENTA, SUM(PRECIO_TOTAL) VENTA_TOTAL
FROM UNIX.Factura f
JOIN UNIX.BI_Tiempo t ON (t.ANIO =  YEAR(FACTURA_FECHA) AND t.MES = MONTH(FACTURA_FECHA))
JOIN UNIX.BI_Sucursal s ON (s.SUCURSAL_CODIGO = f.SUCURSAL_CODIGO)
JOIN UNIX.Cliente cl ON (cl.CLIENTE_CODIGO = f.CLIENTE_CODIGO)
WHERE TIPO_PRODUCTO = 'AM'
GROUP BY TIEMPO_CODIGO, s.SUCURSAL_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC)
ORDER BY TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO;

--------------------------- HECHO AUTOPARTE COMPRA -----------------------------

INSERT INTO UNIX.BI_HechoAutoparteCompra (TIEMPO_CODIGO, SUCURSAL_CODIGO, AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO, CANTIDAD_TOTAL_COMPRADA, COMPRA_TOTAL)
SELECT
  TIEMPO_CODIGO,
  s.SUCURSAL_CODIGO,
  ca.AUTO_PARTE_CODIGO,
  dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC) CLIENTE_EDAD_CODIGO,
  SUM(COMPRA_CANT) CANTIDAD_TOTAL_COMPRADA, SUM(PRECIO_TOTAL) COMPRA_TOTAL
FROM UNIX.Compra c
JOIN UNIX.CompraPorAutoparte ca ON(c.COMPRA_NRO=ca.COMPRA_NRO)
JOIN UNIX.BI_Tiempo t ON (t.ANIO =  YEAR(COMPRA_FECHA) AND t.MES = MONTH(COMPRA_FECHA))
JOIN UNIX.BI_Sucursal s ON (s.SUCURSAL_CODIGO = c.SUCURSAL_CODIGO)
JOIN UNIX.Cliente cl ON (cl.CLIENTE_CODIGO = c.CLIENTE_CODIGO)
WHERE TIPO_COMPRA = 'AP'
GROUP BY TIEMPO_CODIGO, s.SUCURSAL_CODIGO,AUTO_PARTE_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC)
ORDER BY TIEMPO_CODIGO, SUCURSAL_CODIGO, AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO;

--------------------------- HECHO AUTOPARTE VENTA -----------------------------

INSERT INTO UNIX.BI_HechoAutoparteVenta (TIEMPO_CODIGO, SUCURSAL_CODIGO,AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO, CANTIDAD_TOTAL_VENDIDA, VENTA_TOTAL)
SELECT
  TIEMPO_CODIGO,
  s.SUCURSAL_CODIGO,AUTO_PARTE_CODIGO,
  dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC) CLIENTE_EDAD_CODIGO,
  SUM(CANT_FACTURADA) CANTIDAD_TOTAL_VENDIDA, SUM(PRECIO_TOTAL) VENTA_TOTAL
FROM UNIX.Factura f
JOIN UNIX.ItemAutoparte ia ON(f.FACTURA_NRO=ia.FACTURA_NRO)
--JOIN UNIX.BI_Autoparte aut ON(ia.AUTO_PARTE_CODIGO=aut.AUTO_PARTE_CODIGO)
JOIN UNIX.BI_Tiempo t ON (t.ANIO =  YEAR(FACTURA_FECHA) AND t.MES = MONTH(FACTURA_FECHA))
JOIN UNIX.BI_Sucursal s ON (s.SUCURSAL_CODIGO = f.SUCURSAL_CODIGO)
JOIN UNIX.Cliente cl ON (cl.CLIENTE_CODIGO = f.CLIENTE_CODIGO)
WHERE TIPO_PRODUCTO = 'AP'
GROUP BY TIEMPO_CODIGO, s.SUCURSAL_CODIGO,AUTO_PARTE_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC)
ORDER BY TIEMPO_CODIGO, SUCURSAL_CODIGO,AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO;

COMMIT TRANSACTION


---------------------------------------------------------  VISTAS  ------------------------------------------------------

BEGIN TRANSACTION

------------------------------- AUTOMOVIL --------------------------------------------------

----------  Cantidad de automóviles, vendidos y comprados x sucursal y mes
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Automoviles_Cantidad_Comprados_Vendidos AS
SELECT
  SUCURSAL_CODIGO,ANIO, MES,
  SUM(CANTIDAD_TOTAL_COMPRADA) CANTIDAD_TOTAL_COMPRADA,
  SUM(CANTIDAD_TOTAL_VENDIDA) CANTIDAD_TOTAL_VENDIDA
FROM
(
  SELECT
    COALESCE(ac.TIEMPO_CODIGO, av.TIEMPO_CODIGO) TIEMPO_CODIGO,
    COALESCE(ac.SUCURSAL_CODIGO, av.SUCURSAL_CODIGO) SUCURSAL_CODIGO,
    COALESCE(ac.CLIENTE_EDAD_CODIGO, av.CLIENTE_EDAD_CODIGO) CLIENTE_EDAD_CODIGO,
    COALESCE(CANTIDAD_TOTAL_COMPRADA, 0) CANTIDAD_TOTAL_COMPRADA,
    COALESCE(CANTIDAD_TOTAL_VENDIDA, 0) CANTIDAD_TOTAL_VENDIDA
  FROM UNIX.BI_HechoAutomovilCompra ac
  FULL OUTER JOIN UNIX.BI_HechoAutomovilVenta av 
    ON (
      av.TIEMPO_CODIGO = ac.TIEMPO_CODIGO AND
      av.SUCURSAL_CODIGO = ac.SUCURSAL_CODIGO AND
      av.CLIENTE_EDAD_CODIGO = ac.CLIENTE_EDAD_CODIGO
      )
) avc
JOIN UNIX.BI_Tiempo t ON (t.TIEMPO_CODIGO = avc.TIEMPO_CODIGO)
GROUP BY SUCURSAL_CODIGO,ANIO, MES
GO

----------  Ganancias (precio de venta – precio de compra) x Sucursal x mes
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Automoviles_Ganancias AS
SELECT SUCURSAL_CODIGO, ANIO, MES, GANANCIAS
FROM
(
  SELECT
    COALESCE(ac.TIEMPO_CODIGO, av.TIEMPO_CODIGO) TIEMPO_CODIGO,
    COALESCE(ac.SUCURSAL_CODIGO, av.SUCURSAL_CODIGO) SUCURSAL_CODIGO,
    COALESCE(av.VENTA_TOTAL, 0) - COALESCE(ac.COMPRA_TOTAL, 0) GANANCIAS
  FROM UNIX.BI_HechoAutomovilCompra ac
  FULL OUTER JOIN UNIX.BI_HechoAutomovilVenta av 
    ON (
      av.TIEMPO_CODIGO = ac.TIEMPO_CODIGO AND
      av.SUCURSAL_CODIGO = ac.TIEMPO_CODIGO AND
      av.CLIENTE_EDAD_CODIGO = ac.CLIENTE_EDAD_CODIGO
      )
) avc
JOIN UNIX.BI_Tiempo t ON (t.TIEMPO_CODIGO = avc.TIEMPO_CODIGO)
GO

----------  Promedio de tiempo en stock de cada modelo de automóvil.
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Automoviles_Stock AS
SELECT m.MODELO_CODIGO, MODELO_NOMBRE, PROMEDIO_TIEMPO_STOCK
FROM UNIX.BI_HechoModelo em
JOIN UNIX.BI_Modelo m ON (m.MODELO_CODIGO = em.MODELO_CODIGO)
GO

----------  Precio promedio de automóviles, vendidos y comprados.
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Automoviles_Precio_Promedio AS
SELECT 
  CAST((SELECT SUM(COMPRA_TOTAL) / SUM(CANTIDAD_TOTAL_COMPRADA) FROM UNIX.BI_HechoAutomovilCompra) AS DECIMAL(18,2))
  PRECIO_PROMEDIO_COMPRA,
  CAST((SELECT SUM(VENTA_TOTAL) / SUM(CANTIDAD_TOTAL_VENDIDA) FROM UNIX.BI_HechoAutomovilVenta) AS DECIMAL(18,2))
  PRECIO_PROMEDIO_VENTA
GO

------------------------------- AUTOPARTE --------------------------------------------------
----------  Precio promedio de autopartes, vendidas y compradas
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Autopartes_Precio_Promedio AS
SELECT 
  CAST((SELECT SUM(COMPRA_TOTAL) / SUM(CANTIDAD_TOTAL_COMPRADA) FROM UNIX.BI_HechoAutoparteCompra) AS DECIMAL(18,2))
  PRECIO_PROMEDIO_COMPRA,
  CAST((SELECT SUM(VENTA_TOTAL) / SUM(CANTIDAD_TOTAL_VENDIDA) FROM UNIX.BI_HechoAutoparteVenta) AS DECIMAL(18,2))
  PRECIO_PROMEDIO_VENTA
GO

----------  Ganancias (precio de venta – precio de compra) x Sucursal x mes
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Autopartes_Ganancias AS
SELECT SUCURSAL_CODIGO, ANIO, MES, GANANCIAS
FROM
  (
  SELECT TIEMPO_CODIGO, SUCURSAL_CODIGO, SUM(VENTA_TOTAL) - SUM(COMPRA_TOTAL) GANANCIAS
  FROM 
  (
    SELECT
      COALESCE(ac.TIEMPO_CODIGO, av.TIEMPO_CODIGO) TIEMPO_CODIGO,
      COALESCE(ac.SUCURSAL_CODIGO, av.SUCURSAL_CODIGO) SUCURSAL_CODIGO,
      COALESCE(av.VENTA_TOTAL, 0) VENTA_TOTAL,
      COALESCE(ac.COMPRA_TOTAL, 0) COMPRA_TOTAL
    FROM UNIX.BI_HechoAutoparteCompra ac
    FULL OUTER JOIN UNIX.BI_HechoAutoparteVenta av
      ON (
        av.TIEMPO_CODIGO = ac.TIEMPO_CODIGO AND
        av.SUCURSAL_CODIGO = ac.TIEMPO_CODIGO AND
        av.CLIENTE_EDAD_CODIGO = ac.CLIENTE_EDAD_CODIGO AND
        av.AUTO_PARTE_CODIGO = ac.AUTO_PARTE_CODIGO
        )
  ) t_comp_vent
  GROUP BY TIEMPO_CODIGO, SUCURSAL_CODIGO
) avc
JOIN UNIX.BI_Tiempo t ON (t.TIEMPO_CODIGO = avc.TIEMPO_CODIGO)
GO

----------  Máxima cantidad de stock por cada sucursal (anual)

GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Autopartes_Stock_mensual_sucursal AS
SELECT SUCURSAL_CODIGO, ANIO, MES, DIFF_STOCK_COMPRADO,
  CASE TIEMPO_CODIGO
    WHEN 1 THEN
      DIFF_STOCK_COMPRADO
    ELSE
      SUM(SUM(DIFF_STOCK_COMPRADO))
      OVER (PARTITION BY SUCURSAL_CODIGO ORDER BY SUCURSAL_CODIGO, TIEMPO_CODIGO ASC)
  END AS STOCK_ACUMULADO
FROM
(
  SELECT SUCURSAL_CODIGO, t.TIEMPO_CODIGO, t.ANIO, t.MES,
  SUM(CANTIDAD_TOTAL_COMPRADA) - SUM(CANTIDAD_TOTAL_VENDIDA) DIFF_STOCK_COMPRADO
  FROM
  (
    SELECT
      COALESCE(ac.TIEMPO_CODIGO, av.TIEMPO_CODIGO) TIEMPO_CODIGO,
      COALESCE(ac.SUCURSAL_CODIGO, av.SUCURSAL_CODIGO) SUCURSAL_CODIGO,
      COALESCE(av.CANTIDAD_TOTAL_VENDIDA, 0) CANTIDAD_TOTAL_VENDIDA,
      COALESCE(ac.CANTIDAD_TOTAL_COMPRADA, 0) CANTIDAD_TOTAL_COMPRADA
    FROM UNIX.BI_HechoAutoparteCompra ac
    FULL OUTER JOIN UNIX.BI_HechoAutoparteVenta av
      ON (
        av.TIEMPO_CODIGO = ac.TIEMPO_CODIGO AND
        av.SUCURSAL_CODIGO = ac.TIEMPO_CODIGO AND
        av.AUTO_PARTE_CODIGO = ac.AUTO_PARTE_CODIGO
        )
  ) t_comp_vent
  JOIN UNIX.BI_Tiempo t ON (t.TIEMPO_CODIGO = t_comp_vent.TIEMPO_CODIGO)
  GROUP BY SUCURSAL_CODIGO, t.TIEMPO_CODIGO, t.ANIO, t.MES
) autopartes_diff_stocks_mensuales
GROUP BY SUCURSAL_CODIGO, TIEMPO_CODIGO, ANIO, MES, DIFF_STOCK_COMPRADO
GO

GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Autopartes_Stock_Max_Anual AS
SELECT SUCURSAL_CODIGO, ANIO, MAX(STOCK_ACUMULADO) MAX_STOCK_ACUMULADO, MAX(DIFF_STOCK_COMPRADO) MAX_DIFF_STOCK_COMPRADO_UN_MES
FROM UNIX.BI_Vista_Autopartes_Stock_mensual_sucursal
GROUP BY SUCURSAL_CODIGO, ANIO
GO


COMMIT TRANSACTION
