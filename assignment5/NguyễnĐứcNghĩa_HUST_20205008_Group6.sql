﻿

-- Câu 1: 
-- Từ bảng DimProduct, DimSalesTerritory và FactInternetSales, hãy truy vấn ra các thông tin sau 
-- của các đơn hàng được đặt trong năm 2013 và 2014:SELECT B.SalesOrderNumber ,B.SalesOrderLineNumber,B.ProductKey,B.SalesTerritoryCountry,B.OrderQuantity,B.SalesAmount ,DP.EnglishProductName FROM  DimProduct AS DP INNER JOIN 
(SELECT SalesOrderNumber, SalesOrderLineNumber,FIS.ProductKey,DST.SalesTerritoryCountry,FIS.OrderQuantity,FIS.SalesAmount 
FROM DimSalesTerritory AS DST INNER JOIN FactInternetSales AS FIS ON DST.SalesTerritoryKey = FIS.SalesTerritoryKey AND YEAR(FIS.OrderDate) in ('2013','2014'))
AS B  ON B.ProductKey = DP.ProductKey 
-- Câu 2:
--Từ bảng DimProduct, DimSalesTerritory và FactInternetSales, tính tổng doanh thu (đặt tên là 
--InternetTotalSales) và số đơn hàng (đặt tên là NumberofOrders) của từng sản phẩm theo mỗi 
--quốc gia từ bảng DimSalesTerritory. Kết quả trả về gồm có các thông tin sau:
--SalesTerritoryCountry
--ProductKey
--EnglishProductName
--InternetTotalSales
--NumberofOrders

SELECT DP.ProductKey,A.SalesTerritoryCountry,DP.EnglishProductName,A.InternetTotalSales,A.NumberofOrders FROM DimProduct AS DP INNER JOIN 
(SELECT  ProductKey,DST.SalesTerritoryCountry,FIS.SalesTerritoryKey,SUM(TotalProductCost) AS InternetTotalSales ,SUM(SalesOrderLineNumber) AS NumberofOrders 
FROM DimSalesTerritory AS DST INNER JOIN FactInternetSales as FIS ON DST.SalesTerritoryKey = FIS.SalesTerritoryKey 
GROUP BY FIS.SalesTerritoryKey,DST.SalesTerritoryCountry,FIS.ProductKey
) AS A ON A.ProductKey = DP.ProductKey ORDER BY A.SalesTerritoryCountry DESC
-- Câu 3: Từ bảng DimProduct, DimSalesTerritory và FactInternetSales, hãy tính toán % tỷ trọng doanh 
-- thu của từng sản phẩm (đặt tên là PercentofTotaInCountry) trong Tổng doanh thu của mỗi quốc gia
-- SalesTerritoryCountry
--ProductKey
--EnglishProductName
--InternetTotalSales
--PercentofTotaInCountry (định dạng %)
-------
SELECT	C.SalesTerritoryCountry,C.ProductKey,C.InternetTotalSales, (C.InternetTotalSales *100 )/ (SELECT InternetTotal FROM ( SELECT SUM(TotalProductCost)  AS InternetTotal,DST.SalesTerritoryCountry 
FROM DimSalesTerritory AS DST , FactInternetSales as FIS WHERE  DST.SalesTerritoryKey = FIS.SalesTerritoryKey
GROUP BY DST.SalesTerritoryCountry ) AS D WHERE C.SalesTerritoryCountry = D.SalesTerritoryCountry) AS  PercentofTotaInCountry
FROM (SELECT DP.ProductKey,A.SalesTerritoryCountry,DP.EnglishProductName,A.InternetTotalSales,A.NumberofOrders FROM DimProduct AS DP INNER JOIN 
(SELECT  ProductKey,DST.SalesTerritoryCountry,FIS.SalesTerritoryKey,SUM(TotalProductCost) AS InternetTotalSales ,SUM(SalesOrderLineNumber) AS NumberofOrders 
FROM DimSalesTerritory AS DST INNER JOIN FactInternetSales as FIS ON DST.SalesTerritoryKey = FIS.SalesTerritoryKey 
GROUP BY FIS.SalesTerritoryKey,DST.SalesTerritoryCountry,FIS.ProductKey) AS A ON A.ProductKey = DP.ProductKey  ) AS C 
