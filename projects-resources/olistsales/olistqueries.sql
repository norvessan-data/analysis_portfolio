USE olist;

-- make first row the headers in one of the table.
EXEC sp_rename 'olist_orders_dataset.C1', 'order_id', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C2', 'customer_id', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C3', 'order_status', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C4', 'order_purchase_timestamp', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C5', 'order_approved_at', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C6', 'order_delivered_carrier_date', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C7', 'order_delivered_customer_date', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C8', 'order_estimated_delivery_date', 'COLUMN';
DELETE FROM olist_orders_dataset WHERE order_id = 'order_id' AND customer_id = 'customer_id';

SELECT order_id,
       payment_sequential,
       IIF(payment_type = 'boleto', 'cash', REPLACE(payment_type, '_', ' ')) AS cleaned_payment_type,
       payment_installments,
       payment_value
FROM olist_order_payments_dataset;

SELECT op.product_id,
       op.product_category_name
FROM olist_products_dataset AS op;


CREATE OR ALTER FUNCTION dbo.string_clean_capitalize
(
    @stringvar AS NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @startspaceindex TINYINT,
            @outputstr NVARCHAR(100) = '',
            @finishspaceindex TINYINT,
            @strvarlen TINYINT
    -- set the indexes for starting space and the next space symbols
    SET @stringvar = TRIM(@stringvar)
    SET @startspaceindex = CHARINDEX(' ', @stringvar)
    SET @finishspaceindex = CHARINDEX(' ', @stringvar, @startspaceindex)
    SET @strvarlen = LEN(@stringvar)
    -- check if the string consists of one word
    IF @strvarlen = 0
        RETURN NULL
    IF @startspaceindex = 0
        RETURN UPPER(SUBSTRING(@stringvar, 1, 1)) + SUBSTRING(@stringvar, 2, @strvarlen - 1)
    -- initialize the output string by assigning the first word of the string
    SET @outputstr += UPPER(SUBSTRING(@stringvar, 1, 1)) + SUBSTRING(@stringvar, 2, @startspaceindex - 1)

    WHILE LEN(@outputstr) <> @strvarlen
    BEGIN
            SET @startspaceindex = CHARINDEX(' ', @stringvar, DATALENGTH(@outputstr) / 2)
            SET @finishspaceindex = IIF(
                    CHARINDEX(' ', @stringvar, @startspaceindex + 1) = 0,
                    @strvarlen,
                    CHARINDEX(' ', @stringvar, @startspaceindex + 1)
            )
            IF @finishspaceindex = @startspaceindex + 1 AND @finishspaceindex <> @strvarlen
                BEGIN
                SET @stringvar = SUBSTRING(@stringvar, 1, @startspaceindex) + SUBSTRING(@stringvar, @startspaceindex + 2, @strvarlen - @finishspaceindex)
                SET @strvarlen = LEN(@stringvar)
                END
            ELSE
                IF @finishspaceindex - @startspaceindex < 4 AND @finishspaceindex <> @strvarlen OR (@finishspaceindex = @strvarlen AND @finishspaceindex - @startspaceindex < 3)
                     SET @outputstr += SUBSTRING(@stringvar, @startspaceindex + 1, @finishspaceindex - @startspaceindex)
                ELSE
                    SET @outputstr += UPPER(SUBSTRING(@stringvar, @startspaceindex + 1, 1)) + SUBSTRING(@stringvar, @startspaceindex + 2, @finishspaceindex - @startspaceindex - 1)
    end
    RETURN @outputstr
end
CREATE OR ALTER FUNCTION dbo.space_count (
    @stringvar AS NVARCHAR(50)
)
RETURNS INT
BEGIN
    DECLARE @curindex AS INT = 1
    DECLARE @isdoublspace AS INT = 0
    DECLARE @i AS INT = 1
    DECLARE @strlen AS INT = LEN(@stringvar)
    SET @stringvar = TRIM(@stringvar)

    WHILE @i < @strlen
    BEGIN
        IF SUBSTRING(@stringvar, @i, 1) = ' '
            BEGIN
            IF @i = @curindex + 1
                SET @isdoublspace += 1
            SET @curindex = @i
            END

        SET @i += 1
    end
    RETURN @isdoublspace
end

CREATE VIEW olist_sellers_dataset_cleaned
AS
WITH capitalized_wospaces AS (
    SELECT os.seller_id,
           os.seller_zip_code_prefix,
           dbo.string_clean_capitalize(seller_city) as seller_city,
           os.seller_state
    FROM olist_sellers_dataset as os
),
cleaned_wosymbols AS (
    SELECT c1.seller_id,
           CAST(seller_zip_code_prefix AS INT) AS seller_zip_code_prefix,
           CASE
               WHEN seller_city LIKE '%-%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('-', seller_city, 1) - 1))
               WHEN seller_city LIKE '%/%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('/', seller_city, 1) - 1))
               WHEN seller_city LIKE '%~%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('~', seller_city, 1) - 1))
               WHEN seller_city LIKE '%(%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('(', seller_city, 1) - 1))
               WHEN seller_city LIKE '%\%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('\', seller_city, 1) - 1))
               WHEN seller_city LIKE '%,%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX(',', seller_city, 1) - 1))
               WHEN seller_city LIKE '%@%' AND seller_zip_code_prefix = 87025 THEN 'Maringa'
               WHEN seller_city LIKE 's %' THEN 'Sao' + SUBSTRING(seller_city, 2, LEN(seller_city) - 1)
               ELSE seller_city
           END AS seller_city,
           c1.seller_state

    FROM capitalized_wospaces AS c1
)
SELECT cw.seller_id,
       cw.seller_zip_code_prefix,
       cw.seller_city,
       cw.seller_state
FROM cleaned_wosymbols AS cw;

CREATE OR ALTER VIEW olist_products_dataset_cleaned
AS
WITH translated_name AS (
    SELECT p.product_id,
           REPLACE(
                   IIF(
                       p.product_category_name LIKE '%portateis_cozinha%',
                       'small_kitchen_appliances_and_food_preparers',
                       pt.product_category_name_english
                   ),
                   '_',
                   ' '
           ) as product_category,
           p.product_name_lenght,
           p.product_description_lenght,
           p.product_photos_qty,
           p.product_weight_g,
           p.product_length_cm,
           p.product_height_cm,
           p.product_width_cm
    FROM olist_products_dataset as p
    LEFT JOIN product_category_name_translation as pt
    ON p.product_category_name = pt.product_category_name
)
SELECT product_id,
       dbo.string_clean_capitalize(product_category) as product_category,
       product_name_lenght,
       product_description_lenght,
       product_photos_qty,
       product_weight_g,
       product_length_cm,
       product_height_cm,
       product_width_cm
FROM translated_name;
CREATE VIEW olist_customers_dataset_cleaned
AS
SELECT customer_id,
       customer_unique_id,
       customer_zip_code_prefix,
       IIF(
            customer_city LIKE '%dix-sept%',
            'Governador Dix-Sept Rosado',
            dbo.string_clean_capitalize(REPLACE(customer_city, '-', ' '))
       ) AS customer_city,
       customer_state
FROM olist_customers_dataset;
CREATE OR ALTER VIEW olist_geolocation_dataset_cleaned
AS
WITH standardized_geo AS(
    SELECT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        TRANSLATE(
            geolocation_city,
            N'áàãâäÁÀÃÂÄéèêëÉÈÊËíìîïÍÌÎÏóòõôöÓÒÕÔÖúùûüÚÙÛÜçÇñÑ',
            N'aaaaaAAAAAeeeeEEEEiiiiIIIIoooooOOOOOuuuuUUUUcCnN'
        ) AS geolocation_city,
        geolocation_state
    FROM olist_geolocation_dataset
),
prefixcords_averaged AS(
    SELECT
        AVG(geolocation_lat) AS geolocation_lat,
        AVG(geolocation_lng) AS geolocation_lng,
        geolocation_zip_code_prefix
    FROM
        standardized_geo
    GROUP BY
        geolocation_zip_code_prefix
),
distinct_prefix AS(
    SELECT
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS geolocation_lat,
        AVG(geolocation_lng) AS geolocation_lng,
        MIN(geolocation_city) AS geolocation_city,
        MIN(geolocation_state) AS geolocation_state
    FROM
        standardized_geo
    GROUP BY
        geolocation_zip_code_prefix
)
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    dbo.string_clean_capitalize(geolocation_city) AS geolocation_city,
    geolocation_state
FROM
    distinct_prefix;
USE olist;


EXEC sp_rename 'olist_orders_dataset.C1', 'order_id', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C2', 'customer_id', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C3', 'order_status', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C4', 'order_purchase_timestamp', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C5', 'order_approved_at', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C6', 'order_delivered_carrier_date', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C7', 'order_delivered_customer_date', 'COLUMN';
EXEC sp_rename 'olist_orders_dataset.C8', 'order_estimated_delivery_date', 'COLUMN';
DELETE FROM olist_orders_dataset WHERE order_id = 'order_id' AND customer_id = 'customer_id';

SELECT order_id,
       payment_sequential,
       IIF(payment_type = 'boleto', 'cash', REPLACE(payment_type, '_', ' ')) AS cleaned_payment_type,
       payment_installments,
       payment_value
FROM olist_order_payments_dataset;

SELECT op.product_id,
       op.product_category_name
FROM olist_products_dataset AS op;


CREATE OR ALTER FUNCTION dbo.string_clean_capitalize
(
    @stringvar AS NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @startspaceindex TINYINT,
            @outputstr NVARCHAR(100) = '',
            @finishspaceindex TINYINT,
            @strvarlen TINYINT
    
    SET @stringvar = TRIM(@stringvar)
    SET @startspaceindex = CHARINDEX(' ', @stringvar)
    SET @finishspaceindex = CHARINDEX(' ', @stringvar, @startspaceindex)
    SET @strvarlen = LEN(@stringvar)
    
    IF @strvarlen = 0
        RETURN NULL
    IF @startspaceindex = 0
        RETURN UPPER(SUBSTRING(@stringvar, 1, 1)) + SUBSTRING(@stringvar, 2, @strvarlen - 1)
    
    SET @outputstr += UPPER(SUBSTRING(@stringvar, 1, 1)) + SUBSTRING(@stringvar, 2, @startspaceindex - 1)

    WHILE LEN(@outputstr) <> @strvarlen
    BEGIN
            SET @startspaceindex = CHARINDEX(' ', @stringvar, DATALENGTH(@outputstr) / 2)
            SET @finishspaceindex = IIF(
                    CHARINDEX(' ', @stringvar, @startspaceindex + 1) = 0,
                    @strvarlen,
                    CHARINDEX(' ', @stringvar, @startspaceindex + 1)
            )
            IF @finishspaceindex = @startspaceindex + 1 AND @finishspaceindex <> @strvarlen
                BEGIN
                SET @stringvar = SUBSTRING(@stringvar, 1, @startspaceindex) + SUBSTRING(@stringvar, @startspaceindex + 2, @strvarlen - @finishspaceindex)
                SET @strvarlen = LEN(@stringvar)
                END
            ELSE
                IF @finishspaceindex - @startspaceindex < 4 AND @finishspaceindex <> @strvarlen OR (@finishspaceindex = @strvarlen AND @finishspaceindex - @startspaceindex < 3)
                     SET @outputstr += SUBSTRING(@stringvar, @startspaceindex + 1, @finishspaceindex - @startspaceindex)
                ELSE
                    SET @outputstr += UPPER(SUBSTRING(@stringvar, @startspaceindex + 1, 1)) + SUBSTRING(@stringvar, @startspaceindex + 2, @finishspaceindex - @startspaceindex - 1)
    end
    RETURN @outputstr
end
CREATE OR ALTER FUNCTION dbo.space_count (
    @stringvar AS NVARCHAR(50)
)
RETURNS INT
BEGIN
    DECLARE @curindex AS INT = 1
    DECLARE @isdoublspace AS INT = 0
    DECLARE @i AS INT = 1
    DECLARE @strlen AS INT = LEN(@stringvar)
    SET @stringvar = TRIM(@stringvar)

    WHILE @i < @strlen
    BEGIN
        IF SUBSTRING(@stringvar, @i, 1) = ' '
            BEGIN
            IF @i = @curindex + 1
                SET @isdoublspace += 1
            SET @curindex = @i
            END

        SET @i += 1
    end
    RETURN @isdoublspace
end

CREATE VIEW olist_sellers_dataset_cleaned
AS
WITH capitalized_wospaces AS (
    SELECT os.seller_id,
           os.seller_zip_code_prefix,
           dbo.string_clean_capitalize(seller_city) as seller_city,
           os.seller_state
    FROM olist_sellers_dataset as os
),
cleaned_wosymbols AS (
    SELECT c1.seller_id,
           CAST(seller_zip_code_prefix AS INT) AS seller_zip_code_prefix,
           CASE
               WHEN seller_city LIKE '%-%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('-', seller_city, 1) - 1))
               WHEN seller_city LIKE '%/%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('/', seller_city, 1) - 1))
               WHEN seller_city LIKE '%~%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('~', seller_city, 1) - 1))
               WHEN seller_city LIKE '%(%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('(', seller_city, 1) - 1))
               WHEN seller_city LIKE '%\%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX('\', seller_city, 1) - 1))
               WHEN seller_city LIKE '%,%' THEN TRIM(SUBSTRING(seller_city, 1, CHARINDEX(',', seller_city, 1) - 1))
               WHEN seller_city LIKE '%@%' AND seller_zip_code_prefix = 87025 THEN 'Maringa'
               WHEN seller_city LIKE 's %' THEN 'Sao' + SUBSTRING(seller_city, 2, LEN(seller_city) - 1)
               ELSE seller_city
           END AS seller_city,
           c1.seller_state

    FROM capitalized_wospaces AS c1
)
SELECT cw.seller_id,
       cw.seller_zip_code_prefix,
       cw.seller_city,
       cw.seller_state
FROM cleaned_wosymbols AS cw;

CREATE OR ALTER VIEW olist_products_dataset_cleaned
AS
WITH translated_name AS (
    SELECT p.product_id,
           REPLACE(
                   IIF(
                       p.product_category_name LIKE '%portateis_cozinha%',
                       'small_kitchen_appliances_and_food_preparers',
                       pt.product_category_name_english
                   ),
                   '_',
                   ' '
           ) as product_category,
           p.product_name_lenght,
           p.product_description_lenght,
           p.product_photos_qty,
           p.product_weight_g,
           p.product_length_cm,
           p.product_height_cm,
           p.product_width_cm
    FROM olist_products_dataset as p
    LEFT JOIN product_category_name_translation as pt
    ON p.product_category_name = pt.product_category_name
)
SELECT product_id,
       dbo.string_clean_capitalize(product_category) as product_category,
       product_name_lenght,
       product_description_lenght,
       product_photos_qty,
       product_weight_g,
       product_length_cm,
       product_height_cm,
       product_width_cm
FROM translated_name;
CREATE VIEW olist_customers_dataset_cleaned
AS
SELECT customer_id,
       customer_unique_id,
       customer_zip_code_prefix,
       IIF(
            customer_city LIKE '%dix-sept%',
            'Governador Dix-Sept Rosado',
            dbo.string_clean_capitalize(REPLACE(customer_city, '-', ' '))
       ) AS customer_city,
       customer_state
FROM olist_customers_dataset;
CREATE OR ALTER VIEW olist_geolocation_dataset_cleaned
AS
WITH standardized_geo AS(
    SELECT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        TRANSLATE(
            geolocation_city,
            N'áàãâäÁÀÃÂÄéèêëÉÈÊËíìîïÍÌÎÏóòõôöÓÒÕÔÖúùûüÚÙÛÜçÇñÑ',
            N'aaaaaAAAAAeeeeEEEEiiiiIIIIoooooOOOOOuuuuUUUUcCnN'
        ) AS geolocation_city,
        geolocation_state
    FROM olist_geolocation_dataset
),
prefixcords_averaged AS(
    SELECT
        AVG(geolocation_lat) AS geolocation_lat,
        AVG(geolocation_lng) AS geolocation_lng,
        geolocation_zip_code_prefix
    FROM
        standardized_geo
    GROUP BY
        geolocation_zip_code_prefix
),
distinct_prefix AS(
    SELECT
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS geolocation_lat,
        AVG(geolocation_lng) AS geolocation_lng,
        MIN(geolocation_city) AS geolocation_city,
        MIN(geolocation_state) AS geolocation_state
    FROM
        standardized_geo
    GROUP BY
        geolocation_zip_code_prefix
)
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    dbo.string_clean_capitalize(geolocation_city) AS geolocation_city,
    geolocation_state
FROM
    distinct_prefix;


CREATE VIEW olist_orders_dataset_cleaned
AS
SELECT *
FROM olist_orders_dataset;

CREATE VIEW olist_order_items_dataset_cleaned
AS
SELECT *
FROM olist_order_items_dataset;






CREATE VIEW olist_orders_dataset_cleaned
AS
SELECT *
FROM olist_orders_dataset;

CREATE VIEW olist_order_items_dataset_cleaned
AS
SELECT *
FROM olist_order_items_dataset;


