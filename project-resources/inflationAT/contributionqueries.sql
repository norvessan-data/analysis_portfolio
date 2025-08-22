CREATE VIEW contribution_hierarchy
AS
--Unpivot the table
WITH trs
AS
(
	SELECT
		   CASE
				WHEN Coicop = 'CP02201' THEN 'CP0221'
			ELSE Coicop
			END AS Coicop,
		   Category,
		   REPLACE(up.Year, '_', '') as Year,
		   up.Value
	FROM hicpcontribution as r
	UNPIVOT
	(
		Value FOR Year in (_2016, _2017, _2018, _2019, _2020, _2021, _2022, _2023, _2024)
	) up
),
--Sum up the values of the consecutive rank in hierarchy
second_sum
AS
(
	SELECT LEFT(Coicop, 4) as Coicop, Year,  SUM(Value) as Value2
	FROM trs
	WHERE LEN(Coicop) = 5
	GROUP BY LEFT(Coicop, 4), Year

),
third_sum
AS
(
	SELECT LEFT(Coicop, 5) AS Coicop, Year,  SUM(Value) as Value3
	FROM trs
	WHERE LEN(Coicop) = 6
	GROUP BY LEFT(Coicop, 5), Year
),
fourth_sum
AS
(
	SELECT LEFT(Coicop, 6) AS Coicop, Year, SUM(Value) as Value4
	FROM trs
	WHERE LEN(Coicop) = 7
	GROUP BY LEFT(Coicop, 6), Year
),
--Calculate the difference between the initial parent and the sum of its children to fill up the difference as "Other" subcategory 
differences
AS
(
	SELECT t.Coicop, t.Year, t.Value - ss.Value2 as Difference12, t.Value - ts.Value3 as Difference13, t.Value - fs.Value4 as Difference14 
	FROM trs as t
	LEFT JOIN second_sum as ss
	ON t.Coicop = ss.Coicop AND t.Year = ss.Year
	LEFT JOIN third_sum as ts
	ON t.Coicop = ts.Coicop AND t.Year = ts.Year
	LEFT JOIN fourth_sum as fs
	ON t.Coicop = fs.Coicop AND t.Year = fs.Year
	WHERE t.Value - ss.Value2 > 0.0002 OR t.Value - ts.Value3 > 0.0002 OR t.Value - fs.Value4 > 0.0002
),
--Assign the Other subcat as another child to according parent
fourdigitother
AS
(
	select Coicop + '0' as Coicop, 'Other' as Category, Year, Difference12 as Value 
	from differences 
	WHERE LEN(Coicop) = 4 
),
fivedigitother
AS
(
	select Coicop + '0' as Coicop, 'Other' as Category, Year, Difference13 as Value 
	from differences 
	WHERE LEN(Coicop) = 5 
)

--Assign the parents value to 0

SELECT t.Coicop,
	   t.Category,
	   t.Year,
	   CASE
			WHEN t.Coicop IN (
								SELECT LEFT(Coicop, LEN(t.Coicop)) 
								FROM trs as t2 
								WHERE LEN(t2.Coicop) = LEN(t.Coicop) + 1
			)
			THEN 0
			ELSE t.Value 
			END AS Value
FROM trs as t
UNION ALL
SELECT * FROM fourdigitother
UNION ALL
SELECT * FROM fivedigitother;
