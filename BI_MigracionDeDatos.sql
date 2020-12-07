BEGIN TRANSACTION

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

COMMIT


----------------------- TABLA DE HECHOS ---------------------------------------
BEGIN TRANSACTION

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
JOIN #TablaTemporal t ON (t.MODELO_CODIGO = m.MODELO_CODIGO)


COMMIT TRANSACTION

--CANTIDAD COMPRADA AUTOMOVIL Y PRECIO COMPRA

SELECT SUCURSAL_CODIGO, MONTH(COMPRA_FECHA) mes, YEAR(COMPRA_FECHA) anio, 
		COUNT(*) cantidad_comprada, SUM(c.PRECIO_TOTAL) precio_compra,AVG(PRECIO_TOTAL) promedio_compra
FROM UNIX.COMPRA c
WHERE TIPO_COMPRA = 'AM'
GROUP BY SUCURSAL_CODIGO, MONTH(COMPRA_FECHA),YEAR(COMPRA_FECHA)
ORDER BY mes, anio

--CANTIDAD VENDIDA AUTOMOVIL Y PRECIO VENDIDO

SELECT SUCURSAL_CODIGO, MONTH(FACTURA_FECHA) mes, YEAR(FACTURA_FECHA) anio,
		COUNT(*) cantidad_vendida, SUM(PRECIO_TOTAL) precio_vendido, AVG(PRECIO_TOTAL) promedio_venta
FROM UNIX.Factura f
WHERE TIPO_PRODUCTO = 'AM'
GROUP BY SUCURSAL_CODIGO, MONTH(FACTURA_FECHA),YEAR(FACTURA_FECHA)
ORDER BY mes, anio

-- GANANCIAS COMPRA AUTOPARTE

SELECT SUCURSAL_CODIGO, MONTH(COMPRA_FECHA) mes, YEAR(COMPRA_FECHA) anio,
	  SUM(PRECIO_TOTAL) precio_vendido 
FROM UNIX.COMPRA c
WHERE TIPO_COMPRA = 'AP'
GROUP BY SUCURSAL_CODIGO, MONTH(COMPRA_FECHA),YEAR(COMPRA_FECHA)
ORDER BY mes, anio


--VENTAS AUTOPARTE

SELECT SUCURSAL_CODIGO, MONTH(FACTURA_FECHA) mes, YEAR(FACTURA_FECHA) anio,
	  SUM(PRECIO_TOTAL) precio_vendido 
FROM UNIX.Factura f
WHERE TIPO_PRODUCTO = 'AP'
GROUP BY SUCURSAL_CODIGO, MONTH(FACTURA_FECHA),YEAR(FACTURA_FECHA)
ORDER BY mes, anio
