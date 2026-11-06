-- =====================================================================
-- Análisis exploratorio de ventas minoristas en Google BigQuery
-- Dataset: retail_sales (tablas sales, stores, features)
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Vista previa y volumen
-- ---------------------------------------------------------------------
SELECT * FROM `retail_sales.sales` LIMIT 5;
SELECT * FROM `retail_sales.features` LIMIT 5;
SELECT * FROM `retail_sales.stores` LIMIT 5;

SELECT COUNT(*) AS n FROM `retail_sales.sales`;
SELECT COUNT(*) AS n FROM `retail_sales.features`;
SELECT COUNT(*) AS n FROM `retail_sales.stores`;

-- ---------------------------------------------------------------------
-- 2. Rangos de las variables numéricas
-- ---------------------------------------------------------------------
SELECT MIN(Weekly_Sales) AS min_weekly_sales,
       MAX(Weekly_Sales) AS max_weekly_sales
FROM `retail_sales.sales`;

SELECT MIN(Temperature)  AS min_temp,  MAX(Temperature)  AS max_temp,
       MIN(Fuel_Price)   AS min_fuel,  MAX(Fuel_Price)   AS max_fuel,
       MIN(CPI)          AS min_cpi,   MAX(CPI)          AS max_cpi,
       MIN(Unemployment) AS min_unemp, MAX(Unemployment) AS max_unemp
FROM `retail_sales.features`;

SELECT MIN(Size) AS min_size, MAX(Size) AS max_size
FROM `retail_sales.stores`;

-- ---------------------------------------------------------------------
-- 3. Variables categóricas
-- ---------------------------------------------------------------------
SELECT Type, COUNT(*) AS n
FROM `retail_sales.stores`
GROUP BY Type
ORDER BY n DESC;

SELECT IsHoliday, COUNT(*) AS n
FROM `retail_sales.sales`
GROUP BY IsHoliday
ORDER BY n DESC;

-- ---------------------------------------------------------------------
-- 4. Calidad de datos: valores anómalos y nulos
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS n_negative
FROM `retail_sales.sales`
WHERE Weekly_Sales < 0;

SELECT COUNTIF(CPI IS NULL)          AS null_cpi,
       COUNTIF(Unemployment IS NULL) AS null_unemployment
FROM `retail_sales.features`;

-- ---------------------------------------------------------------------
-- 5. Vista enriquecida: ventas + tienda + variables contextuales
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW `retail_sales.vw_sales_enriched` AS
SELECT
  s.Store, s.Dept, s.Date, s.Weekly_Sales, s.IsHoliday AS IsHoliday_sales,
  st.Type, st.Size,
  f.Temperature, f.Fuel_Price, f.CPI, f.Unemployment, f.IsHoliday AS IsHoliday_features
FROM `retail_sales.sales` s
JOIN `retail_sales.stores` st
  ON s.Store = st.Store
LEFT JOIN `retail_sales.features` f
  ON s.Store = f.Store AND s.Date = f.Date;

-- ---------------------------------------------------------------------
-- 6. Negocio: ventas medias y totales por tipo de tienda
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW `retail_sales.vw_sales_by_type` AS
SELECT
  Type,
  AVG(Weekly_Sales) AS avg_weekly_sales,
  SUM(Weekly_Sales) AS total_weekly_sales,
  COUNT(*) AS n_rows
FROM `retail_sales.vw_sales_enriched`
GROUP BY Type;

-- ---------------------------------------------------------------------
-- 7. Negocio: efecto de las semanas festivas por tipo de tienda
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW `retail_sales.vw_sales_by_type_holiday` AS
SELECT
  Type,
  IsHoliday_sales AS IsHoliday,
  AVG(Weekly_Sales) AS avg_weekly_sales,
  SUM(Weekly_Sales) AS total_weekly_sales,
  COUNT(*) AS n_rows
FROM `retail_sales.vw_sales_enriched`
GROUP BY Type, IsHoliday_sales;

SELECT
  Type,
  IsHoliday_sales AS IsHoliday,
  AVG(Weekly_Sales) AS avg_sales
FROM `retail_sales.vw_sales_enriched`
GROUP BY Type, IsHoliday_sales
ORDER BY Type, IsHoliday;

-- ---------------------------------------------------------------------
-- 8. Negocio: ventas normalizadas por tamaño de tienda
-- ---------------------------------------------------------------------
SELECT
  Type,
  AVG(Weekly_Sales / NULLIF(Size, 0)) AS avg_sales_per_size
FROM `retail_sales.vw_sales_enriched`
GROUP BY Type
ORDER BY avg_sales_per_size DESC;

-- ---------------------------------------------------------------------
-- 9. Negocio: proporción de ventas negativas (devoluciones/ajustes) por tipo
-- ---------------------------------------------------------------------
SELECT
  Type,
  COUNTIF(Weekly_Sales < 0) AS n_negative,
  COUNT(*) AS n_total,
  SAFE_DIVIDE(COUNTIF(Weekly_Sales < 0), COUNT(*)) AS pct_negative
FROM `retail_sales.vw_sales_enriched`
GROUP BY Type
ORDER BY pct_negative DESC;
