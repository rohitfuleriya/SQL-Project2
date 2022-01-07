CREATE DATABASE Superstores;
USE Superstores;
           
                                 /*Task 1:- Understanding the Data */
                                 
/*Question 1. Describe the data in hand in your own words. */   
/*
The dataset was provided in “csv” format thus it’s cleaned before importing into SQL workbench.

In the given Database of Superstore, in all there are 5 tables.
Cust_dimen, market_fact, orders_dimen, prod_dimen and shipping_ dimen.

Cust_dimen:     table provides the overall information about the customers.
Prod_dimen:     table provides the information about the categories and sub-categories of products.
Shipping_dimen: table provides the shipping information about the orders.
Orders_dimen:   table provides the dates of orders received with their priorities.
Market_fact:    shows the detail of sales along with profit, shipping cost, discount and product base margin.
*/ 
/*      
1) CUST_DIMEN:
		Customer_Name (TEXT): Name of the customer
        Province (TEXT): Province of the customer
        Region (TEXT): Region of the customer
        Customer_Segment (TEXT): Segment of the customer
        Cust_id (INT): Unique Customer ID
        
2)MARKET_FACT:
		Ord_id (INT): Order ID
        Prod_id (INT): Prod ID
        Ship_id (INT): Shipment ID
        Cust_id (INT): Customer ID
        Sales (DOUBLE): Sales from the Item sold
        Discount (DOUBLE): Discount on the Item sold
        Order_Quantity (INT): Order Quantity of the Item sold
        Profit (DOUBLE): Profit from the Item sold
        Shipping_Cost (DOUBLE): Shipping Cost of the Item sold
        Product_Base_Margin (DOUBLE): Product Base Margin on the Item sold
        
3)ORDERS_DIMEN:
		Order_ID (INT): Order ID
        Order_Date (TEXT): Order Date
        Order_Priority (TEXT): Priority of the Order
        Ord_id (INT): Unique Order ID
        
4)PROD_DIMEN:
		Product_Category (TEXT): Product Category
        Product_Sub_Category (TEXT): Product Sub Category
        Prod_id (INT): Unique Product ID
        
5)SHIPPING_DIMEN:
		Order_ID (INT): Order ID
        Ship_Mode (TEXT): Shipping Mode
        Ship_Date (TEXT): Shipping Date
        Ship_id (INT): Unique Shipment ID
        
*/

/*
Cust_dimen	:PRIMARY KEY:Cust_id	
			 FOREIGN KEY:NA
             
Market_fact	:PRIMARY KEY: NA	
			 FOREIGN KEY:Cust_id, Ord_id, Prod_id, Ship_id
             
Orders_dimen: PRIMARY KEY: Ord_id	
			  FOREIGN KEY:NA
( Ord_id as Primary Key, although Order_ID is also there but it is advisable to use Ord_id as primary Key to ensure relationship consistency. 
  But Order_ID will be used as a foreign key in shipping_dimen will help retrieve the details)
Prod_dimen:PRIMARY KEY: Prod_id	
		   FOREIGN KEY:NA
Shipping_dimen: PRIMARY KEY:Ship_id	
				                FOREIGN KEY:order_id
                                
*/
		                       

use superstores;
show tables;

SELECT 
    *
FROM
    cust_dimen;

    
SELECT 
    *
FROM
    prod_dimen;

    
SELECT 
    *
FROM
    orders_dimen;

    
SELECT 
    *
FROM
    shipping_dimen;
    
    
SELECT 
    *
FROM
    market_fact;
    
    
                                    /*Task 2- Basic & Advanced Analysis */
use Superstores;                                    
/*Question 1. Write a query to display the Customer_Name and Customer Segment using alias 
name “Customer Name", "Customer Segment" from table Cust_dimen. */    
SELECT 
    customer_name AS 'Customer Name',
    customer_segment AS 'Customer Segment'
FROM
    cust_dimen; 

/*Question 2. Write a query to find all the details of the customer from the table cust_dimen 
order by desc*/    
SELECT 
    *
FROM
    cust_dimen
ORDER BY cust_id DESC;  

/*Question 3. Write a query to get the Order ID, Order date from table orders_dimen where 
‘Order Priority’ is high.*/                                           
 SELECT 
    order_id, order_date
FROM
    orders_dimen
WHERE
    order_priority = 'high';
    
/*Question 4. Find the total and the average sales (display total_sales and avg_sales)*/    
SELECT 
    SUM(sales) AS total_sales, AVG(sales) AS avg_sales
FROM
    market_fact;
    
/*Question 5. Write a query to get the maximum and minimum sales from maket_fact table.*/ 
SELECT 
    MAX(sales) AS 'maximum sales', MIN(sales) AS 'minimum sales'
FROM
    market_fact;  
    
/*Question 6. Display the number of customers in each region in decreasing order of 
no_of_customers. The result should contain columns Region, no_of_customers.*/
SELECT 
    Region, COUNT(Cust_id) AS 'No. of Customers'
FROM
    cust_dimen
GROUP BY Region
ORDER BY COUNT(Cust_id);  
 
 /*7. Find the region having maximum customers (display the region name and 
max(no_of_customers)*/
SELECT 
    Region, COUNT(Cust_id) AS 'No. of Customers'
FROM
    cust_dimen
GROUP BY Region
ORDER BY COUNT(Cust_id) DESC
LIMIT 1;

/* Question 8. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ 
and the number of tables purchased (display the customer name, no_of_tables 
purchased) */ 
SELECT 
    c.Region AS 'Region',
    c.Customer_Name AS 'Customer Name',
    p.Product_Sub_Category AS 'Product Sub Category',
    SUM(m.Order_Quantity) AS 'Order Quantity'
FROM
    market_fact m
        JOIN
    cust_dimen c ON m.Cust_id = c.Cust_id
        JOIN
    prod_dimen p ON m.Prod_id = p.Prod_id
WHERE
    c.Region = 'ATLANTIC'
        AND p.Product_Sub_Category = 'TABLES'
GROUP BY c.Customer_Name
ORDER BY SUM(m.Order_Quantity) DESC;

/*Question 10. Find the number and id of products sold in decreasing order of products sold 
(display product id, no_of_products sold)  */
 SELECT 
    prod_id AS product_id, COUNT(*) AS no_of_products_sold
FROM
    market_fact
GROUP BY prod_id
ORDER BY no_of_products_sold DESC;
  
/* Question 12. Display the product categories in descending order of profits (display the product 
category wise profits i.e. product_category, profits)?*/
 SELECT 
    p.product_category, SUM(m.profit) AS profits
FROM
    market_fact m
        INNER JOIN
    prod_dimen p ON m.prod_id = p.prod_id
GROUP BY p.product_category
ORDER BY profits DESC;

/* Question 13. Display the product category, product sub-category and the profit within each 
subcategory in three columns. */
SELECT 
    p.product_category, p.product_sub_category, SUM(m.profit) AS profits
	FROM
    market_fact m
	INNER JOIN
    prod_dimen p ON m.prod_id = p.prod_id
	GROUP BY p.product_category, p.product_sub_category;

/* Question 14. Display the order date, order quantity and the sales for the order.*/
SELECT 
    a.order_date, b.order_quantity, b.sales
FROM
    orders_dimen a
        INNER JOIN
    market_fact b ON a.ord_id = b.ord_id;
    
/* Question 15. Display the names of the customers whose name contains the 
 i) Second letter as ‘R’
 ii) Fourth letter as ‘D’*/

SELECT 
    customer_name
FROM
    cust_dimen
WHERE
    customer_name LIKE '_r_d%';
/* Question 16. Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and 
their region where sales are between 1000 and 5000.*/
SELECT 
    b.cust_id, b.customer_name, b.region, a.sales
FROM
    cust_dimen b
        INNER JOIN
    market_fact a
WHERE
    b.cust_id = a.cust_id
        AND a.sales BETWEEN 1000 AND 5000;

/* Question 17. Write a SQL query to find the 3rd highest sales.*/
SELECT 
    sales
FROM
    market_fact
ORDER BY sales DESC
LIMIT 2 , 1;


/* Question 18. Where is the least profitable product subcategory shipped the most? For the least 
profitable product sub-category, display the region-wise no_of_shipments and the 
profit made in each region in decreasing order of profits (i.e. region, 
no_of_shipments, profit_in_each_region)*/
SELECT 
    c.Region AS 'Region',
    COUNT(m.Ship_id) AS 'No of Shipments',
    ROUND(SUM(m.Profit), 2) AS 'Profit in each region'
FROM
    market_fact m
        JOIN
    cust_dimen c ON m.Cust_id = c.Cust_id
        JOIN
    prod_dimen p ON m.Prod_id = p.Prod_id
WHERE
    Product_Sub_Category = (SELECT 
            p.Product_Sub_Category
        FROM
            market_fact m
                JOIN
            prod_dimen p ON m.Prod_id = p.Prod_id
        GROUP BY Product_Sub_Category
        ORDER BY SUM(m.Profit)
        LIMIT 1)
GROUP BY c.Region
ORDER BY SUM(m.Profit);

