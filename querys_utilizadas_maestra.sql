--------------------------------------------------------------------------
----------------     Tabla Maestra:Consultas utilizadas   -----------------

-- Cantidad de registros totales
SELECT COUNT(*) FROM gd_esquema.Maestra;

-- Tipo de dato de cada campo
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE FROM information_schema.columns
WHERE TABLE_NAME = 'Maestra'
ORDER BY COLUMN_NAME;

-- Top 100 primeros registros
SELECT TOP(100) * FROM gd_esquema.Maestra WHERE FAC_CLIENTE_DNI IS NOT NULL;



--- Las fecha de las facturas son posteriores a las compras
SELECT COMPRA_FECHA, FACTURA_FECHA
FROM gd_esquema.Maestra
WHERE COMPRA_FECHA > FACTURA_FECHA;

-- Todas las facturas tienen precio
SELECT FACTURA_NRO,  PRECIO_FACTURADO
FROM gd_esquema.Maestra
WHERE FACTURA_NRO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL;



-- Factura: Cantidad facturada coincide con los campos repetidos

SELECT FACTURA_NRO, CANT_FACTURADA, COUNT( AUTO_PARTE_CODIGO) Cantidad_De_Autopartes, 
COUNT(DISTINCT PRECIO_FACTURADO) Cantidad_De_PRECIOS
FROM gd_esquema.Maestra
WHERE FACTURA_NRO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NOT NULL
AND AUTO_PATENTE IS NULL
AND PRECIO_FACTURADO IS NOT NULL
GROUP BY FACTURA_NRO, CANT_FACTURADA
ORDER BY FACTURA_NRO;


SELECT FACTURA_NRO, CANT_FACTURADA, COUNT(AUTO_PARTE_CODIGO)
FROM gd_esquema.Maestra
WHERE FACTURA_NRO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NOT NULL
AND AUTO_PATENTE IS NULL
AND PRECIO_FACTURADO IS NOT NULL
AND FACTURA_NRO = 47838198
GROUP BY FACTURA_NRO, CANT_FACTURADA
ORDER BY FACTURA_NRO;





---------------------------------  Automoviles     ---------------------------------

-- Automoviles: Todos tienen patentes (No existen automoviles sin patente)

SELECT AUTO_PATENTE, AUTO_NRO_CHASIS
FROM gd_esquema.Maestra
WHERE AUTO_NRO_CHASIS IS NOT NULL 
AND AUTO_PATENTE IS NULL;

-- Automoviles: Cada Factura tiene SOLO UN Automovil, el precio corresponde al automovil.

SELECT FACTURA_NRO, COUNT(DISTINCT AUTO_PATENTE) Cantidad_De_Autos, COUNT(DISTINCT PRECIO_FACTURADO) Cantidad_De_PRECIOS
FROM gd_esquema.Maestra
WHERE FACTURA_NRO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NULL
AND AUTO_PATENTE IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
GROUP BY FACTURA_NRO;


-- Automoviles: No existe Factura con más de un automovil

SELECT FACTURA_NRO, COUNT(DISTINCT AUTO_PATENTE) Cantidad_De_Autos, COUNT(DISTINCT PRECIO_FACTURADO) Cantidad_De_PRECIOS
FROM gd_esquema.Maestra
WHERE FACTURA_NRO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NULL
AND AUTO_PATENTE IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
GROUP BY FACTURA_NRO
HAVING COUNT(DISTINCT AUTO_PATENTE) > 1;

-- Automovil: Precio de Compra es distinto a Precio Facturado

SELECT AUTO_PATENTE, COMPRA_PRECIO, PRECIO_FACTURADO
FROM gd_esquema.Maestra 
WHERE AUTO_PATENTE IS NOT NULL
AND COMPRA_PRECIO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL;

-- Automovil: Todos los autos tienen compra  (No existe auto sin Compra)

SELECT COMPRA_PRECIO, PRECIO_FACTURADO
FROM gd_esquema.Maestra 
WHERE AUTO_PATENTE IS NOT NULL
AND COMPRA_PRECIO IS  NULL;

---------------------------------   Autopartes      ----------------------------------

-- Para toda Autoparte: Si existe FACTURA -> No existe COMPRA

SELECT COMPRA_PRECIO, PRECIO_FACTURADO, AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION
FROM gd_esquema.Maestra 
WHERE AUTO_PARTE_CODIGO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND COMPRA_PRECIO IS NULL;

-- Para toda Autoparte: Si existe FACTURA -> No existe COMPRA

SELECT COMPRA_PRECIO, PRECIO_FACTURADO, AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION
FROM gd_esquema.Maestra 
WHERE AUTO_PARTE_CODIGO IS NOT NULL
AND COMPRA_PRECIO IS NOT NULL
AND PRECIO_FACTURADO IS  NULL;

-- Para toda Autoparte: No puede existir Factura y Compra a la vez

SELECT COMPRA_PRECIO, PRECIO_FACTURADO, AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION
FROM gd_esquema.Maestra 
WHERE AUTO_PARTE_CODIGO IS NOT NULL
AND COMPRA_PRECIO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL;


-- Para toda Autoparte: Si existe factura -> No existe Compra
SELECT COMPRA_PRECIO, PRECIO_FACTURADO, AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION
FROM gd_esquema.Maestra 
WHERE AUTO_PARTE_CODIGO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND COMPRA_PRECIO IS NOT NULL;

-- Existe una factura con muchas autopartes. El precio facturado corresponde al precio de cada autoparte

SELECT FACTURA_NRO, CANT_FACTURADA, COUNT( AUTO_PARTE_CODIGO) Cantidad_De_Autopartes, 
COUNT(DISTINCT PRECIO_FACTURADO) Cantidad_De_PRECIOS
FROM gd_esquema.Maestra
WHERE FACTURA_NRO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NOT NULL
AND AUTO_PATENTE IS NULL
AND PRECIO_FACTURADO IS NOT NULL
GROUP BY FACTURA_NRO, CANT_FACTURADA
ORDER BY FACTURA_NRO;

-- Autoparte-Compra:  Misma para compra distintos precios

SELECT COMPRA_NRO, COUNT( AUTO_PARTE_CODIGO) Cantidad_De_Autopartes, 
COUNT(DISTINCT COMPRA_PRECIO) Cantidad_De_PRECIOS
FROM gd_esquema.Maestra
WHERE COMPRA_NRO IS NOT NULL
AND COMPRA_PRECIO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NOT NULL
AND AUTO_PATENTE IS NULL
GROUP BY COMPRA_NRO
ORDER BY COMPRA_NRO;


-- AUTO_PARTE COMPRA cada autoparte tiene unico precio
SELECT  AUTO_PARTE_CODIGO, COUNT(DISTINCT COMPRA_PRECIO) CantidadPrecios
FROM gd_esquema.Maestra 
WHERE COMPRA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL 
GROUP BY AUTO_PARTE_CODIGO
HAVING COUNT(DISTINCT COMPRA_PRECIO)>1

-- AUTO_PARTE-COMPRA cada autoparte tiene varias compras
SELECT  AUTO_PARTE_CODIGO, COUNT(DISTINCT COMPRA_NRO) CantidadPrecios
FROM gd_esquema.Maestra 
WHERE COMPRA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL 
GROUP BY AUTO_PARTE_CODIGO
HAVING COUNT(DISTINCT COMPRA_NRO)>1

-- AUTO_PARTE COMPRA precio de cada autoparte
SELECT  AUTO_PARTE_CODIGO, COMPRA_PRECIO
FROM gd_esquema.Maestra 
WHERE COMPRA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL 
GROUP BY AUTO_PARTE_CODIGO, COMPRA_PRECIO
ORDER BY AUTO_PARTE_CODIGO

--ITEM_AUTOPARTE En una factura dos auto_parte_iguales

INSERT INTO UNIX.ItemAutoparte
SELECT FACTURA_NRO, COUNT(DISTINCT AUTO_PARTE_CODIGO) Norepetidos, COUNT(AUTO_PARTE_CODIGO) Repetidos
FROM gd_esquema.Maestra
WHERE AUTO_PARTE_CODIGO IS NOT NULL and FACTURA_NRO IS NOT NULL
GROUP BY FACTURA_NRO



--AUTO-PARTE FACTUTRA : cada autoparte tiene unico precio de factura
SELECT AUTO_PARTE_CODIGO, COUNT (DISTINCT PRECIO_FACTURADO) CantidadPreciosFacturados
FROM gd_esquema.Maestra
WHERE FACTURA_NRO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NOT NULL
AND AUTO_PATENTE IS NULL
AND PRECIO_FACTURADO IS NOT NULL
GROUP BY AUTO_PARTE_CODIGO
HAVING COUNT (DISTINCT PRECIO_FACTURADO) > 1 
ORDER BY AUTO_PARTE_CODIGO;

--AUTO_PARTE FABRICANTE
SELECT AUTO_PARTE_CODIGO, COUNT(DISTINCT FABRICANTE_NOMBRE) CantFabricantes FROM gd_esquema.Maestra 
WHERE COMPRA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL 
GROUP BY AUTO_PARTE_CODIGO

-- Las facturas de autopartes pueden tener muchas autopartes

SELECT FACTURA_NRO, COUNT(DISTINCT AUTO_PARTE_CODIGO) Cantidad_De_Autopartes
FROM gd_esquema.Maestra
WHERE FACTURA_NRO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NOT NULL
AND AUTO_PATENTE IS NULL
GROUP BY FACTURA_NRO;

-- Autopartes: Existe una factura con muchas autopartes. El precio facturado corresponde al precio de cada autoparte

SELECT FACTURA_NRO, COUNT(DISTINCT AUTO_PARTE_CODIGO) Cantidad_De_Autopartes, COUNT(DISTINCT PRECIO_FACTURADO) Cantidad_De_PRECIOS
FROM gd_esquema.Maestra
WHERE FACTURA_NRO IS NOT NULL
AND PRECIO_FACTURADO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NOT NULL
AND AUTO_PATENTE IS NULL
AND PRECIO_FACTURADO IS NOT NULL
GROUP BY FACTURA_NRO
ORDER BY FACTURA_NRO;

-- Autopartes : Una factura tiene muchos precios y muchas autopartes

SELECT FACTURA_NRO,  AUTO_PARTE_CODIGO , PRECIO_FACTURADO
FROM gd_esquema.Maestra
WHERE FACTURA_NRO = 47870407
AND PRECIO_FACTURADO IS NOT NULL
AND AUTO_PARTE_CODIGO IS NOT NULL
AND AUTO_PATENTE IS NULL;

---------------------------------   Clientes      ----------------------------------

-- Creacion de Tabla temporal CLIENTES
SELECT CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION
INTO #clientes
FROM gd_esquema.Maestra;

-- Creacion de Tabla Temporal CLIENTES_FACTURAS
SELECT FAC_CLIENTE_DNI, FAC_CLIENTE_NOMBRE, FAC_CLIENTE_APELLIDO, FAC_CLIENTE_DIRECCION
INTO #facturas
FROM gd_esquema.Maestra;

-- CLIENTES y CLIENTES_FACTURA con mismo DNI  => Son personas distintas
SELECT * FROM #clientes c JOIN  #facturas f ON (f.FAC_CLIENTE_DNI = c.CLIENTE_DNI);

-- CLIENTES y CLIENTES_FACTURA con mismo Nombre y Apellido  => Son personas distintas
SELECT * FROM #clientes c
JOIN  #facturas f ON (f.FAC_CLIENTE_APELLIDO = c.CLIENTE_APELLIDO  AND f.FAC_CLIENTE_NOMBRE = c.CLIENTE_NOMBRE);

SELECT * FROM #clientes WHERE CLIENTE_APELLIDO = 'Acosta' and CLIENTE_NOMBRE= 'Adelqui'

-- No existe CLIENTE sin compras

SELECT CLIENTE_DNI, COUNT(COMPRA_FECHA) Cantidad_De_Compras FROM gd_esquema.Maestra
GROUP BY CLIENTE_DNI
HAVING COUNT(COMPRA_FECHA) = 0;

-- Existen FAC_CLIENTE sin compras

SELECT FAC_CLIENTE_DNI, COUNT(COMPRA_FECHA) Cantidad_De_Compras FROM gd_esquema.Maestra
GROUP BY FAC_CLIENTE_DNI
HAVING COUNT(COMPRA_FECHA) = 0;

-- Un CLIENTE => Tiene 1 o mas Compras
SELECT CLIENTE_DNI, COUNT(COMPRA_FECHA) Cantidad_De_Compras FROM gd_esquema.Maestra
GROUP BY CLIENTE_DNI;

-- Un FAC_CLIENTE => Tiene 1 o mas Compras
SELECT FAC_CLIENTE_DNI, COUNT(COMPRA_FECHA) Cantidad_De_Compras FROM gd_esquema.Maestra
GROUP BY FAC_CLIENTE_DNI;























--------------------    Otras consultas (Falta ponerle nombres y clasificarlas)     -----------------------

SELECT  MODELO_CODIGO, COUNT(DISTINCT MODELO_NOMBRE),  COUNT(DISTINCT TIPO_AUTO_CODIGO), COUNT(DISTINCT TIPO_AUTO_DESC), COUNT(DISTINCT TIPO_CAJA_CODIGO), 
 COUNT(DISTINCT TIPO_TRANSMISION_CODIGO) ,  COUNT(DISTINCT TIPO_MOTOR_CODIGO)  FROM gd_esquema.Maestra
GROUP BY MODELO_CODIGO
ORDER BY MODELO_CODIGO;


SELECT  TIPO_TRANSMISION_CODIGO, AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION
FROM gd_esquema.Maestra
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL AND
    AUTO_PARTE_CODIGO IS NOT NULL;


SELECT  TIPO_AUTO_CODIGO, TIPO_AUTO_DESC, TIPO_CAJA_DESC, TIPO_TRANSMISION_DESC, TIPO_MOTOR_CODIGO FROM gd_esquema.Maestra
WHERE TIPO_AUTO_DESC IS NOT NULL
ORDER BY TIPO_AUTO_CODIGO;



SELECT  TIPO_AUTO_CODIGO, TIPO_AUTO_DESC, AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, TIPO_CAJA_DESC,  TIPO_MOTOR_CODIGO FROM gd_esquema.Maestra
WHERE AUTO_PARTE_DESCRIPCION IS NOT NULL
ORDER BY TIPO_AUTO_CODIGO;


SELECT MODELO_CODIGO, FABRICANTE_NOMBRE FROM gd_esquema.Maestra;


SELECT MODELO_CODIGO, AUTO_PARTE_CODIGO, FABRICANTE_NOMBRE FROM gd_esquema.Maestra
WHERE AUTO_PARTE_CODIGO IS NOT NULL;





