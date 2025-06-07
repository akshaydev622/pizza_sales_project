-- create database
create database pozza_sales;

-- create tables
create table orders(
order_id int primary key auto_increment,
order_data date not null,
order_time time not null
);

create table order_details(
order_detail_id int primary key auto_increment,
order_id int not null,
pizza_id varchar(50),
quantity int

);

create table pizzas(
pizza_id varchar(15),
pizza_type_id varchar(13),
size varchar(4),
price varchar(5)
);

create pizza_types(
pizza_type_id varchar(15),
name varchar(50),
category varchar(10),
ingredients varchar(100)
);




-- 1. Retrive the total number of orders placed.

select count(order_id) as total_orders from orders;

-- 2. calulate to revenue generated form pizza sales.
select round(sum(order_details.quantity * pizzas.price),2) as total_sales from order_details join pizzas on pizzas.pizza_id = order_details.pizza_id;

-- 3. Identify the highest-price pizza.
select pizza_types.name, pizzas.price from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id order by pizzas.price desc limit 1;

-- 4. Identify the most comman pizza size ordered.
select pizzas.size, count(order_detail_id) as order_count from pizzas join order_details on pizzas.pizza_id = order_details.pizza_id group by pizzas.size order by order desc limit 1;

--5. list the top 5 most ordered pizza types along with their quantity.
select pizza_types.name, sum(order_details.quantity) as quantity from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details
 on order_details.pizza_id = pizzas.pizza_id group by pizza_types.name order by quantity desc limit 5;

-- 6. join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) as quantity from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
    -> join order_details on order_details.pizza_id = pizzas.pizza_id
    -> group by pizza_types.category order by quantity desc;

-- 7. determine the distribution of orders by hour of the day.
SELECT HOUR(order_time), COUNT(order_id) FROM orders GROUP BY HOUR(order_time);

-- 8. jOIN relevant tables to find the category-wise distribution of pizzas.
select category, count(name) from pizza_types group by category;

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(quantity) from (select orders.order_date, sum(order_details.quantity) as quantity from orders join order_details on orders.order_id = order_details.order_id
    -> group by orders.order_date) as order_quantity;

-- 10. Determine the top 3 orderred pizza types based on revenue.
select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue from pizza_types join pizzas on pizzas.pizza_type_id =
    -> pizza_types.pizza_type_id join order_details on order_details.pizza_id = pizzas.pizza_id group by pizza_types.name order by revenue desc
    -> limit 3;