# Requirements

1. Google Account
2. Docker
3. [MySQL Workbench](https://www.mysql.com/products/workbench/) *Optional*
4. Basic Python Knowledge

## Running MySQL with Docker

```
docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
```



# Lab 1

## Create Table
```
mysql -u root
create database sample;
use sample;
create table users(Name varchar(10),Country varchar(10), Card_Number varchar(20));
```

## Insert Data

```
insert into users values ('Tony','France','3542-7583-7228-3788'),('Steve','Austria','3881-8829-5554-4875'),('Peter','Spain','8445-5556-9621-9962');
```

# Check Data

```
select * from users;
```

You can see that when I use the select function, all data is clearly visible. Usually, applications use a select query to fetch data from a database. How can we change this to get masked data? MySQL database has many built-in functions for data masking. I’ll use a simple string-replace approach. The query is as follows:

```
SELECT Name,Country,CONCAT(REGEXP_REPLACE (LEFT(Card_Number,16), '.', 'X'),RIGHT(Card_Number,4)) from users;

```
The logic here is simple. We fetch data for all columns, but for the card number, we replace the first sixteen characters with ‘X’ and concatenate the remaining four characters to the replaced string. 


## Data Masking Best Practices
There are various approaches to data masking, and we need to follow the most secure approaches. We’ve gone through different aspects of data masking and learned how important and easy it is. I’ll conclude with some best practices for data masking.

Find and mask all sensitive data. If you have different databases and places where you store sensitive data, find and mask all of them.
Mask data at the origin. If you think masking data only on the client-side is enough, you’re wrong. Various tools can intercept traffic before it reaches the client application. If you’re masking data after it reaches the client, malicious actors can still get hold of unmasked data from the network.
Use irreversible data masking techniques. The whole point of data masking is to protect sensitive data. If users can convert masked data back to original data, there’s no point in masking it. For example, masking digits with alphabetic characters at the associated positions (1->a, 2->b, 3->c, etc.) is not a secure approach because users can reverse it.


