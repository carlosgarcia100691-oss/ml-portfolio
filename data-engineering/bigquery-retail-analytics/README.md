# Análisis de ventas minoristas con Google Cloud Storage y BigQuery

Análisis exploratorio y de negocio sobre **421.570 registros de ventas semanales** de 45
tiendas, combinando ventas, características de las tiendas y variables macroeconómicas
(temperatura, precio del combustible, IPC, desempleo).

**Stack:** Google Cloud Storage · BigQuery (SQL estándar) · vistas

## Arquitectura

1. Carga de `sales.csv`, `stores.csv` y `features.csv` en un *bucket* de **Cloud Storage**.
2. Creación de tablas en **BigQuery**: tablas **externas** (lectura directa desde GCS) y
   **nativas** (almacenadas en BigQuery).
3. Vista enriquecida `vw_sales_enriched` (JOIN de las tres tablas) para reutilizarla en
   todas las consultas de negocio sin repetir *joins*.
4. Vistas agregadas por tipo de tienda y por semana festiva.

Todas las consultas están en [`queries.sql`](queries.sql).

## Hallazgos

**Calidad de datos**
- 1.285 ventas semanales negativas (0,30 %), interpretables como devoluciones o ajustes
  contables.
- 585 valores nulos en CPI y en desempleo dentro de `features`, que habría que imputar o
  filtrar según el análisis.

**Negocio**
- Las tiendas de **tipo A** concentran el volumen: mayores ventas medias y totales (A > B > C).
- Las **semanas festivas** (7 % de los registros) elevan la venta media en las tiendas A y B;
  en las C el efecto es pequeño.
- Normalizando por superficie (`Weekly_Sales / Size`), el **tipo C** tiene la mayor densidad
  de ventas.
- El tipo B presenta la mayor proporción de ventas negativas (≈ 0,41 %).

## Datos

Ventas semanales de una cadena minorista estadounidense: tablas `sales` (tienda,
departamento, fecha, ventas, festivo), `stores` (tipo y tamaño) y `features` (variables
contextuales por tienda y fecha).
