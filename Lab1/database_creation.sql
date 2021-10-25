SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Customers` (
  `idCustomers` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Address` VARCHAR(45) NULL,
  `Website` VARCHAR(45) NULL,
  `Credit_Limit` FLOAT NULL,
  PRIMARY KEY (`idCustomers`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Employees` (
  `idEmployees` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  `Phone` VARCHAR(45) NULL,
  `HireDate` DATE NULL,
  `ManagerID` INT NULL,
  `JobTitle` VARCHAR(45) NULL,
  PRIMARY KEY (`idEmployees`),
  INDEX `fk_manager_idx` (`ManagerID` ASC) VISIBLE,
  CONSTRAINT `fk_manager`
    FOREIGN KEY (`ManagerID`)
    REFERENCES `mydb`.`Employees` (`idEmployees`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Orders` (
  `idOrders` INT NOT NULL AUTO_INCREMENT,
  `customerID` INT NULL,
  `Status` VARCHAR(45) NULL,
  `SalesmanId` INT NULL,
  `OrderDate` DATE NULL,
  PRIMARY KEY (`idOrders`),
  INDEX `fk_customers_idx` (`customerID` ASC) VISIBLE,
  INDEX `fk_salesman_idx` (`SalesmanId` ASC) VISIBLE,
  CONSTRAINT `fk_customers`
    FOREIGN KEY (`customerID`)
    REFERENCES `mydb`.`Customers` (`idCustomers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_salesman`
    FOREIGN KEY (`SalesmanId`)
    REFERENCES `mydb`.`Employees` (`idEmployees`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Contacts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Contacts` (
  `idContacts` INT NOT NULL AUTO_INCREMENT,
  `First Name` VARCHAR(45) NULL,
  `Last Name` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  `Phone` VARCHAR(45) NULL,
  `customerId` INT NULL,
  PRIMARY KEY (`idContacts`),
  INDEX `fk_customers_contacts_idx` (`customerId` ASC) VISIBLE,
  CONSTRAINT `fk_customers_contacts`
    FOREIGN KEY (`customerId`)
    REFERENCES `mydb`.`Customers` (`idCustomers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Product_Cateogry`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Product_Cateogry` (
  `idProduct_Cateogry` INT NOT NULL AUTO_INCREMENT,
  `Category_Name` VARCHAR(45) NULL,
  PRIMARY KEY (`idProduct_Cateogry`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Products` (
  `idProducts` INT NOT NULL AUTO_INCREMENT,
  `Product_Name` VARCHAR(45) NULL,
  `Description` VARCHAR(45) NULL,
  `Standard_Cost` VARCHAR(45) NULL,
  `List_Price` VARCHAR(45) NULL,
  `Category_ID` INT NULL,
  PRIMARY KEY (`idProducts`),
  INDEX `fk_product_category_idx` (`Category_ID` ASC) VISIBLE,
  CONSTRAINT `fk_product_category`
    FOREIGN KEY (`Category_ID`)
    REFERENCES `mydb`.`Product_Cateogry` (`idProduct_Cateogry`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Regions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Regions` (
  `idRegions` INT NOT NULL AUTO_INCREMENT,
  `Region_Name` VARCHAR(45) NULL,
  PRIMARY KEY (`idRegions`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Countries` (
  `idCountries` INT NOT NULL AUTO_INCREMENT,
  `Country_Name` VARCHAR(45) NULL,
  `RegionID` INT NULL,
  PRIMARY KEY (`idCountries`),
  INDEX `fk_region_idx` (`RegionID` ASC) VISIBLE,
  CONSTRAINT `fk_region`
    FOREIGN KEY (`RegionID`)
    REFERENCES `mydb`.`Regions` (`idRegions`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Locations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Locations` (
  `idLocations` INT NOT NULL AUTO_INCREMENT,
  `Address` VARCHAR(45) NULL,
  `Postal_Code` VARCHAR(45) NULL,
  `City` VARCHAR(45) NULL,
  `State` VARCHAR(45) NULL,
  `Country_ID` INT NULL,
  PRIMARY KEY (`idLocations`),
  INDEX `fk_countries_idx` (`Country_ID` ASC) VISIBLE,
  CONSTRAINT `fk_countries`
    FOREIGN KEY (`Country_ID`)
    REFERENCES `mydb`.`Countries` (`idCountries`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Warehouses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Warehouses` (
  `idWarehouses` INT NOT NULL AUTO_INCREMENT,
  `Warehouse_Name` VARCHAR(45) NULL,
  `Location_ID` INT NULL,
  PRIMARY KEY (`idWarehouses`),
  INDEX `fk_locations_idx` (`Location_ID` ASC) VISIBLE,
  CONSTRAINT `fk_locations`
    FOREIGN KEY (`Location_ID`)
    REFERENCES `mydb`.`Locations` (`idLocations`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Order_Items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Order_Items` (
  `Item_ID` INT NOT NULL AUTO_INCREMENT,
  `Order_ID` INT NOT NULL,
  `ProductID` INT NULL,
  `Quantety` INT NULL,
  `Unit_Price` FLOAT NULL,
  PRIMARY KEY (`Item_ID`, `Order_ID`),
  INDEX `fk_products_item_idx` (`ProductID` ASC) VISIBLE,
  CONSTRAINT `fk_orders`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `mydb`.`Orders` (`idOrders`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_products_item`
    FOREIGN KEY (`ProductID`)
    REFERENCES `mydb`.`Products` (`idProducts`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Inventories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Inventories` (
  `ProductID` INT NOT NULL AUTO_INCREMENT,
  `WharehousID` INT NOT NULL,
  `Quantety` INT NULL,
  PRIMARY KEY (`ProductID`, `WharehousID`),
  INDEX `fk_warehouse_idx` (`WharehousID` ASC) VISIBLE,
  CONSTRAINT `fk_warehouse`
    FOREIGN KEY (`WharehousID`)
    REFERENCES `mydb`.`Warehouses` (`idWarehouses`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_id`
    FOREIGN KEY (`ProductID`)
    REFERENCES `mydb`.`Products` (`idProducts`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- View `mydb`.`customers_view`
-- -----------------------------------------------------
CREATE VIEW `customers_view` AS 
	select * from customers;

-- -----------------------------------------------------
-- View `mydb`.`contacts`
-- -----------------------------------------------------
CREATE VIEW `contacts_view` AS 
	select * from contacts;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
