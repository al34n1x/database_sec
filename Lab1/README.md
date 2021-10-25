# Introduction

We assume that you have a basic SQL knowledge to run the following DDL/DML instructions.
For further references, please visit [SQL Intro](https://www.w3schools.com/sql/sql_intro.asp). Keep in mind that some of the instructions may vary depending on the DBMS vendor. Check the vendor documentation before proceding with the database implementation.
For the purpose of this lab, we will use [MySQL Server](https://dev.mysql.com/doc/)

# Requirements

1. Docker
2. [MySQL Workbench](https://www.mysql.com/products/workbench/) *Optional*
3. Basic SQL Knowledge

## Running MySQL with Docker

```
docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```
Now we are ready to start with the lab.

# Lab 1

## Create Table

As part of this Lab you will create a database from a business requirement.


## Business Requirement
Your organization requires to build the persistency layer using MySQL as your DBMS.
The Enterprise Architect shared the following Entity Relationship Diagram and asked you to build the database.

![](./img/lab_datamodel.png)


## Exercise

Build the database using Data Definition Language (DDL).

Refer to the below example for this use case.

```
CREATE DATABASE MyData; -- Create Database

USE MyData; -- Select DB

-- Create Tables
CREATE TABLE IF NOT EXISTS customers (
  customer_id INT(4) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  address VARCHAR(20) NOT NULL,
  website VARCHAR(40) NOT NULL,
  credit_limit FLOAT(20)
) ENGINE=InnoDB AUTO_INCREMENT=1; -- Identify the engine and id autoincrement 

CREATE TABLE IF NOT EXISTS orders (
  order_id INT(4) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  customer_id INT(4) NOT NULL,
  status VARCHAR(2) NOT NULL,
  emailUsuario VARCHAR(20) NOT NULL,
  CONSTRAINT FOREIGN KEY fk_chat_customer (customer_id) REFERENCES customers (customer_id)
  -- Asigno la llave externa, le doy un nombre random, le asigno el campo de la tabla localy luego le digo
  -- a donde referenciar y el campo de esa tabla externa.
) ENGINE=InnoDB AUTO_INCREMENT=1;

```

NOTE: Please refer to the [Database Creation Script]() if you need further guidance on how to build your database.

## Insert Data

Now that you have created the database, you must inser some data by using Data Manipulation Language (DML).

Refer to the below example.

```
insert into customers values
(default,'John Doe','5th Avenue 123','http://www.website.com', 30000),
(default,'Papa John','Texas Avenue 987','http://www.website2.com', 50000) -- default option allow you to avoid passing the row id
```

# Verify Data Loading
With the data loaded, let's run some queries to pull out data from the tables.


```
select * from customers;
```

```
select 
    c.customer_id as id,
    c.nombre as Nombre,
    c.address as Address,
    c.website as Website,
    c.credit_limit as Credit
  from customers c
```

