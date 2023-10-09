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
    mongosh
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

1. Download the [retail dataset](./data/retail.csv)

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

