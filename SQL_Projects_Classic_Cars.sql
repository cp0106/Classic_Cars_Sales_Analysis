use classicmodels;

# Q.1  for shipped orders Most 5 huge Orders with respect to Total Sales
SELECT ordernumber, sum(quantityOrdered*priceEach) as total_price FROM orders join orderdetails using(ordernumber)group by ordernumber order by 2 desc limit 10;

# Q.2  Total Sales for Product lines in all year

select year(orderDate) as years , productline,  sum(quantityOrdered*priceEach) as total_price from productlines 
join products using(productLine) join orderdetails using(productCode) join orders orders using (ordernumber) group by 1,2 order by 3 desc; 

# Q.3  unique customers for all years

select count(distinct(customerNumber)) as Total_unique_customer , year(orderDate) as years from orders 
where customerNumber in (select customerNumber from customers) group by 2;

with cte1 as (select * from orders 
where customerNumber in (select customerNumber from customers)) 
select distinct(customerNumber) from cte1 where year(orderDate) = '2003' ;

with cte2 as (select * from orders 
where customerNumber in (select customerNumber from customers)) 
select distinct(customerNumber) from cte2 where year(orderDate) = '2004';

with cte3 as (select * from orders 
where customerNumber in (select customerNumber from customers)) 
select distinct(customerNumber) from cte3 where year(orderDate) = '2005';



# New Customers over the Years 
select year(first_order), count(customerNumber) from 
(select customerNumber, min(orderDate) as first_order from orders where customerNumber in (select customerNumber from customers) group by 1) a 
group by 1;


# Q.4  unique products for all years and Top 10 Products with highest Sales

select distinct(productName) as products, sum(quantityOrdered*priceEach) as total_price  from products
join orderdetails using(productCode) group by 1 order by 2 desc limit 10;

with cte as (select *, rank() over (partition by years order by total_price desc) as ranks from 
(select distinct(productName) as products, year(orderDate) as years, sum(quantityOrdered*priceEach) as total_price  from products
join orderdetails using(productCode) join orders using(orderNumber) group by 2,1 order by 2, 3 desc ) a )

select * from cte where ranks <= 10;

#Q.5 Top 10 customers who have got highest creditlimit

select * from customers order by creditLimit desc limit 10 ; 

#Q.6 Top 5 Countries with Highest Sales 

Select country , sum(quantityOrdered*priceEach) as total_price from orders join customers using(customerNumber)
join orderdetails using(orderNumber) group by 1 order by 2 desc limit 5;

#Q.6 Total shipped Qty over the years and other status as well  

select count(*), status, year(orderDate) as years  from orders join orderdetails using(orderNumber) group by 2,3;




