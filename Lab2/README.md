<<<<<<< HEAD
# Requirements

1. Google Account
2. Docker
3. [MySQL Workbench](https://www.mysql.com/products/workbench/) *Optional*
4. Basic Python Knowledge

## Running MySQL with Docker

```
docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
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


=======
# Introduction

We assume that you have a basic command line  and application development knowledge.
For the purpose of this lab we will use 
[mongoDB](https://www.mongodb.com/), a document data model that naturally supports JSON and thanks to its expressive query language is simple for developers to learn and use.
For further references, please visit [mongoDB Doc](https://docs.mongodb.com/). 

# Requirements

1. [Docker](https://docs.docker.com/engine/install/)
2. [Studio3T](https://studio3t.com/download/) or [mongoDB Compass](https://www.mongodb.com/es/products/compass)
3. Basic JSON data structure Knowledge. [JSON](https://www.w3resource.com/JSON/structures.php)

## Running MongoDB with Docker

```
docker run -d --name mongodb -v mydir/mongodb:/data/db -p 27017:27017 mongo:latest
```

Once the container is running, we need to set up the admin password. Open a command line and execute the following commands:

1. Get into the container:
    ```
    docker exec -i -t mongodb bash
    ```

2. Open the mongoDB CLI:
    ```
    mongo
    ```

3. Change to the `admin` database:
    ```
    use admin
    ```

4. Create the user `root` with password `root` alongside with the `root` role:
    ```
    db.createUser({user:"root", pwd:"root", roles:[{role:"root", db:"admin"}]})
    ```

5. Exit mongoDB cli and the container.
    ```
    exit && exit
    ```

## Connecting to the database

With the instance and the `root` user id set up, let's open your mongoDB GUI (either Studio3T or Compass) and connect using the following connection URL or fill the require fields depending on your client.

```
mongodb://root:root@localhost
```

* User: `root`
* Pasword: `root`
* Host: `localhost`
* Port: `27017`


## Exercise

1. Download the [retail dataset](https://raw.githubusercontent.com/al34n1x/DataScience/master/data/retail.csv)

    For those using the mongoDB Cli, you can use the following command

    ```
    mongoimport --type csv -d retail -c retail --headerline --drop retail.csv --authenticationDatabase admin --username root --password root
    ```

2. Import the dataset using your mongoDB client (either Studio3T or Compass)

3. With the data loaded, build your queries to get the following reports
   * List all the items in the collection
   * Orders with invoice number `536365`
   * Orders with invoice number `536365` with quantety less than `8`
   * List orders with product price greater than 5 for client `13047`

>>>>>>> main
