create database pizzahut;
use pizzahut;

create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));

create table order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id));

CREATE TABLE pizzas (
    pizza_id VARCHAR(50) not null,
    pizza_type_id VARCHAR(50) not null,
    size VARCHAR(5) not null,
    price DECIMAL(5,2) not null
);

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) not null,
    name VARCHAR(100) not null,
    category VARCHAR(50) not null,
    ingredients varchar(500) not null
);