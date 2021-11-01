# Requirements

[Visual Studio](https://visualstudio.microsoft.com/es/)

[Visual Studio Plugin](https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql)

## Docker

Install Docker Windows/Mac/Linux

```
MSSQL Docker Hub Image: docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=yourStrong(!)Password" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest
```

# Lab

## Setting up Sample Database

Please remember to create a sample database using the following T-SQL script compatible with SQL Server 2016 or as Azure SQL Database if you would like to follow the walkthrough in this article:


```
-- Create sample database ITSalesV2
CREATE DATABASE ITSalesV2;
GO

USE [ITSalesV2]

-- (2) Create MonthlySale table
CREATE TABLE [dbo].[MonthlySale](
	[SaleId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[SellingDate] [datetime2](7) NULL,
	[Customer] [varchar](50) NULL,
	[Email] [varchar] (200) NULL,
	[Product] [varchar](150) NULL,
	[TotalPrice] [decimal](10, 2) NULL,
)


-- (2) Populate monthly sale table
SET IDENTITY_INSERT [dbo].[MonthlySale] ON
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (1, N'2019-05-01 00:00:00', N'Asif', N'Asif@companytest-0001.com', N'Dell Laptop', CAST(300.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (2, N'2019-05-02 00:00:00', N'Mike',N'Mike@companytest-0002.com', N'Dell Laptop', CAST(300.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (3, N'2019-05-02 00:00:00', N'Adil',N'Adil@companytest-0003.com',N'Lenovo Laptop', CAST(350.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (4, N'2019-05-03 00:00:00', N'Sarah',N'Sarah@companytest-0004', N'HP Laptop', CAST(250.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (5, N'2019-05-05 00:00:00', N'Asif', N'Asif@companytest-0001.com', N'Dell Desktop', CAST(200.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (6, N'2019-05-10 00:00:00', N'Sam',N'Sam@companytest-0005', N'HP Desktop', CAST(300.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (7, N'2019-05-12 00:00:00', N'Mike',N'Mike@companytest-0002.comcom', N'iPad', CAST(250.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (8, N'2019-05-13 00:00:00', N'Mike',N'Mike@companytest-0002.comcom', N'iPad', CAST(250.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (9, N'2019-05-20 00:00:00', N'Peter',N'Peter@companytest-0006', N'Dell Laptop', CAST(350.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[MonthlySale] ([SaleId], [SellingDate], [Customer],[Email], [Product], [TotalPrice]) VALUES (10, N'2019-05-25 00:00:00', N'Peter',N'Peter@companytest-0006', N'Asus Laptop', CAST(400.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[MonthlySale] OFF

```

## Checking Data

```
SELECT
  s.SaleId
 ,s.SellingDate
 ,s.Customer
 ,s.Email
 ,s.Product
 ,s.TotalPrice
FROM dbo.MonthlySale s
```

## Creating a non-privileged user

create a non-privileged user without login having only SELECT permission on the MonthlySale table who is going to see the masked data as a pre-requisite to this article. Use the following script to do that:

```
CREATE USER DataUser WITHOUT LOGIN;  
GRANT SELECT ON MonthlySale TO DataUser;
```

## Creating a Procedure to check masking status

```
CREATE PROC ShowMaskingStatus
AS
BEGIN
SET NOCOUNT ON 
SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function  
FROM sys.masked_columns AS c  
JOIN sys.tables AS tbl   
    ON c.[object_id] = tbl.[object_id]  
WHERE is_masked = 1;
END

```


## Dynamic Data Masking Types

There are four common types of Dynamic data masking in SQL Server:
1. Default Data Mask(s)
2. Partial Data Mask(s)
3. Random Data Mask(s)
4. Custom String Data Mask(s)

## Implementing Default Data Masking

### Business Requirements

Now suppose you receive a business requirement which states that e-mail addresses of the customers should be completely hidden (masked) due to the sensitivity of this information.
The best way to meet this business requirement is to mask the Email column using Dynamic data masking (DDM).

### E-mail Address Default Data Masking

```
ALTER TABLE MonthlySale
ALTER COLUMN Email varchar(200) MASKED WITH (FUNCTION = 'default()');
```

### Checking status

```
EXEC ShowMaskingStatus
```

### Viewing Email Column as a DataUser

```
-- Execute SELECT as DataUser
EXECUTE AS USER = 'DataUser';  

-- View monthly sales 
SELECT s.SaleId,s.SellingDate,s.Customer,s.Email,s.Product,s.Product from dbo.MonthlySale s

-- Revert the User back to what user it was before
REVERT;
```

## Implementing Partial Data Masking

### Business Requirements

Now think of a business requirement in which you have been asked to partially hide the name of the customers in such a way that only the first character of the name remains visible. The best way to meet this business requirement is to mask the Customer column using Partial dynamic data masking.

### Partial Data Masking of Customer Names

```
-- Partial data masking of Customer names
ALTER TABLE MonthlySale
ALTER COLUMN [Customer] ADD MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX",0)')
```

### Checking status

```
EXEC ShowMaskingStatus
```

### Viewing the Customer Column as a DataUser

```
-- Execute SELECT as DataUser
EXECUTE AS USER = 'DataUser';  

-- View monthly sales as DataUser
SELECT s.SaleId,s.SellingDate,s.Customer,s.Email,s.Product,s.Product from dbo.MonthlySale s

-- Revert the User back to what user it was before
REVERT;
```

## Implementing Random Data Masking

### Business Requirement
You receive a business requirement which states that product price should be masked with a random range of numbers so that users with low privileges must not know the exact prices of the product for privacy reasons. The best way to meet this business specification is to mask the TotalPrice column using random dynamic data masking.

### Random Data Masking of the TotalPrice Column

```
--Random dynamic data masking of TotalPrice column 
ALTER TABLE MonthlySale
ALTER COLUMN [TotalPrice] decimal(10,2) MASKED WITH (FUNCTION = 'random(1, 12)')
```

### Checking status

```
EXEC ShowMaskingStatus
```

### Viewing the TotalPrice Column as a DataUser

```
-- Execute SELECT as DataUser
EXECUTE AS USER = 'DataUser';  

-- View monthly sales 
SELECT s.SaleId,s.SellingDate,s.Customer,s.Email,s.Product,s.TotalPrice from dbo.MonthlySale s

-- Revert the User back to what user it was before
REVERT;
```


## Implementing Custom String Data Masking
Custom string data masking as its name implies adds custom character to hide a column by making it very difficult to guess its contents. Please remember that Custom string data masking is used in conjunction with Partial data masking by customizing the character to mask the actual column values. In other words, Custom string data masking is an enhanced form of Partial data masking.

### Business Requirement
Consider a business requirement to only show the first and last character of the Product column while the rest of the characters should be hidden or masked with hyphens (-). The best way to meet this business specification is to mask the Product column using Partial dynamic data masking with the required custom string.


### Customer String Data Masking of Selling Data

```
--Custom string dynamic data masking of Product column 
ALTER TABLE MonthlySale
ALTER COLUMN [Product] ADD MASKED WITH (FUNCTION = 'partial(1,"---",1)')
```

### Checking status

```
EXEC ShowMaskingStatus
```


### Viewing the Product Column as a DataUser

```
-- Execute SELECT as DataUser
EXECUTE AS USER = 'DataUser';  

-- View monthly sales 
SELECT s.SaleId,s.SellingDate,s.Customer,s.Email,s.Product,s.TotalPrice from dbo.MonthlySale s

-- Revert the User back to what user it was before
REVERT;
```


## Best Practices
Please remember the following things:
1. Dynamic data masking does not protect or encrypt the column data so it should not be used for that purpose.
2. The potential user who is supposed to see the masked data must have very limited access to view the data and should not at all be given Update permission to exploit the data.
3. The potential user even with SELECT only permission can run exhaustive queries to guess the correct value so please beware of that.
4. You can also use ALTER COLUMN Email ADD MASKED WITH (FUNCTION = ’email()’) to mask e-mail columns rather than using Default dynamic masking.
5. You can use Custom string data masking to hide a debit card number in a transaction report by showing only the last two or four digits as you might have seen in shopping receipts.


[Source](https://codingsight.com/dynamic-data-masking-in-sql-server-for-advanced-users/?ref=morioh.com&utm_source=morioh.com)
