##Top-Selling Tracks by Sales and Revenue
SELECT 
    t.Name AS TrackName, 
    COUNT(il.track_id) AS NumberOfSales,
    SUM(il.Unit_Price * il.Quantity) AS TotalRevenue
FROM 
    invoice_line il
    JOIN track t ON il.track_id = t.track_id
GROUP BY 
    t.track_id
ORDER BY 
    NumberOfSales DESC
LIMIT 10;

##Top 10 High-Spending Customers
SELECT 
    c.first_name || ' ' || c.last_name AS CustomerName,
    c.email,
    COUNT(i.invoice_id) AS PurchaseCount,
    SUM(i.total) AS TotalSpent,
    AVG(i.total) AS AverageSpentPerPurchase
FROM 
    customer c
    JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY 
    c.customer_id
ORDER BY 
    TotalSpent DESC
LIMIT 10;
##Revenue and Sales by Music Genre
SELECT 
    g.name AS Genre, 
    COUNT(il.track_id) AS NumberOfSales,
    SUM(il.Unit_Price * il.quantity) AS TotalRevenue
FROM 
    invoice_line il
    JOIN track t ON il.track_id = t.track_id
    JOIN album a ON t.album_id = a.album_id
    JOIN genre g ON t.genre_id = g.genre_id
GROUP BY 
    g.genre_id
ORDER BY 
    TotalRevenue DESC;
	
##Sales Performance by Employee	
SELECT 
    e.first_name || ' ' || e.last_name AS EmployeeName,
    COUNT(i.invoice_id) AS NumberOfSales,
    SUM(i.total) AS TotalSales
FROM 
    employee e
    JOIN customer c ON e.employee_Id = c.Support_rep_id
    JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY 
    e.employee_Id
ORDER BY 
    TotalSales DESC;

##Country-wise Sales and Revenue Distribution	
SELECT 
    c.country, 
    COUNT(i.invoice_id) AS NumberOfSales,
    SUM(i.total) AS TotalRevenue
FROM 
    customer c
    JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY 
    c.Country
ORDER BY 
    TotalRevenue DESC;

##Top 10 Best-Selling Albums	
SELECT 
    a.title AS AlbumTitle,
    SUM(ii.unit_Price * ii.quantity) AS TotalSales
FROM 
    invoice_line ii
JOIN 
    track t ON ii.track_id = t.track_id
JOIN 
    album a ON t.album_id = a.album_id
GROUP BY 
    a.title
ORDER BY 
    TotalSales DESC
LIMIT 10;

##Revenue Distribution by Country	
SELECT 
    c.country,
    SUM(ii.Unit_Price * ii.quantity) AS TotalRevenue
FROM 
    invoice i
JOIN 
    invoice_line ii ON i.invoice_id = ii.invoice_id
JOIN 
    customer c ON i.customer_id = c.customer_id
GROUP BY 
    c.Country
ORDER BY 
    TotalRevenue DESC;

##Customer Purchase History by Date
SELECT 
    c.first_Name,
    c.last_Name,
    i.invoice_date,
    SUM(ii.unit_Price * ii.quantity) AS TotalAmount
FROM 
    customer c
JOIN 
    invoice i ON c.customer_Id = i.customer_id
JOIN 
    invoice_line ii ON i.invoice_id = ii.invoice_id
GROUP BY 
    c.first_name, c.last_name, i.invoice_date
ORDER BY 
    c.last_name, i.invoice_date DESC;
	
##Monthly Sales Performance Overview	
SELECT 
    DATE_TRUNC('month', i.invoice_date) AS Month,
    SUM(ii.unit_Price * ii.quantity) AS TotalSales
FROM 
    invoice i
JOIN 
    invoice_line ii ON i.invoice_id = ii.invoice_id
GROUP BY 
    DATE_TRUNC('month', i.invoice_date)
ORDER BY 
    Month;

##Customers with Above-Average Purchase Frequency	
SELECT 
    c.First_Name,
    c.Last_Name,
    invoice_count
FROM (
    SELECT 
        i.Customer_Id,
        COUNT(i.Invoice_Id) AS invoice_count
    FROM 
        Invoice i
    GROUP BY 
        i.Customer_Id
) AS customer_invoice_count
JOIN Customer c ON customer_invoice_count.Customer_Id = c.Customer_Id
WHERE 
    invoice_count > (
        SELECT 
            AVG(invoice_count)
        FROM (
            SELECT 
                COUNT(i.Invoice_Id) AS invoice_count
            FROM 
                Invoice i
            GROUP BY 
                i.Customer_Id
        ) AS avg_invoice_count
    )
ORDER BY 
    invoice_count DESC;

##Purchase History of Top 10 High-Spending Customers
SELECT 
    c.First_Name,
    c.Last_Name,
    i.Invoice_Date,
    ii.Unit_Price,
    ii.Quantity
FROM 
    Invoice i
JOIN 
    Invoice_Line ii ON i.Invoice_Id = ii.Invoice_Id
JOIN 
    Customer c ON i.Customer_Id = c.Customer_Id
WHERE 
    c.Customer_Id IN (
        SELECT 
            i.Customer_Id
        FROM 
            Invoice i
        JOIN 
            Invoice_Line ii ON i.Invoice_Id = ii.Invoice_Id
        GROUP BY 
            i.Customer_Id
        ORDER BY 
            SUM(ii.Unit_Price * ii.Quantity) DESC
        LIMIT 10
    )
ORDER BY 
    c.Last_Name, i.Invoice_Date DESC;
