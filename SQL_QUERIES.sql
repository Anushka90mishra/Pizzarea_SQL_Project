**-- cal total revenue:**

 select 
 round(sum(pizza_details.quantity * pizzas.price),2) as total_rev
 from pizza_details join pizzas
 on pizzas.pizza_id = pizza_details.pizza_id

**-- highest piriced pizza:** 

select pizza_types.name ,pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

**-- most ordered pizza quantity:**

select quantity, count(order_id)
from pizza_details 
group by quantity;


**-- which size of pizza is ordered more?**

select pizzas.size, count(pizza_details.order_details_id) as order_count
from pizzas join pizza_details
on  pizzas.pizza_id = pizza_details.pizza_id
group by pizzas.size;

**-- list 5 most order pizza types with their quantities**

select pizza_types.name, sum(pizza_details.quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join pizza_details 
on pizza_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by total_quantity desc limit 5 ;

**-- joins the neccessary tables to find the total quantity of each pizza category ordered**

select pizza_types.category , sum(pizza_details.quantity) as quantity
from pizza_types join pizzas on
pizza_types.pizza_type_id = pizzas.pizza_type_id
join pizza_details
on pizza_details.pizza_id = pizzas.pizza_id
group by category
order by quantity desc;

**-- determine the distribution on orders by hour of the day:**

select hour(order_time) , count(order_id) from orders
group by hour(order_time); 

**-- Join relevant tables to find the category-wise distribution of pizzas.**

select  category,count(category) from pizza_types
group by category;

**-- Group the orders by date and calculate the average number of pizzas ordered per day.**

select round(avg(quantity_sum),0)as avg_order_per_day from
(select (orders.order_date) , sum(pizza_details.quantity) as quantity_sum
from orders join pizza_details
on orders.order_id = pizza_details.order_id
group by orders.order_date) as order_quantity;

**-- Determine the top 3 most ordered pizza types based on revenue.**

select pizza_types.name,
sum(pizza_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join pizza_details
on pizza_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc limit 3;

**-- Calculate the percentage contribution of each pizza type to total revenue.**

SELECT 
    pizza_types.category,
    ROUND((SUM(pizza_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(pizza_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    pizza_details
                        JOIN
                    pizzas ON pizzas.pizza_id = pizza_details.pizza_id)) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    pizza_details ON pizza_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

**-- Analyze the cumulative revenue generated over time.**

select order_date,
sum(revenue) over(order by order_date) as cumulative_rev
from
(select orders.order_date, 
sum(pizza_details.quantity * pizzas.price) as revenue
from pizza_details join pizzas
on pizza_details.pizza_id = pizzas.pizza_id
join orders 
on orders.order_id = pizza_details.order_id
group by orders.order_date) as sales;



 
