GO
USE [master];
IF DB_ID('AirlineSA') IS NOT NULL
BEGIN
    ALTER DATABASE AirlineSA SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AirlineSA;
END;
GO
CREATE DATABASE AirlineSA;
GO
USE AirlineSA;
GO



DROP TABLE IF EXISTS SA_Aircraft;
GO
CREATE TABLE SA_Aircraft
(
    -- aircraft id and registration
    Aircraft_ID INT,
    Registration_Number VARCHAR(20),
    -- Aircraft information
    Model VARCHAR(50),
    Manufacturer VARCHAR(50),
    Manufacture_Date DATE,
    Engine_Type VARCHAR(50),
    Max_Range_KM INT,
    -- Aircraft specifications
    Passenger_Capacity INT,
    Fuel_Capacity_Liters DECIMAL(10,2),
    Cargo_Capacity_KG INT,
    Is_Active BIT DEFAULT 1,
);



DROP TABLE IF EXISTS SA_Airport;
GO
CREATE TABLE SA_Airport
(
    -- airport information
    Airport_Code VARCHAR(10),
    Airport_Name VARCHAR(100),
    IATA_Code CHAR(3),
    ICAO_Code CHAR(4),
    -- location information
    City VARCHAR(50),
    Country VARCHAR(50),
    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6),
    Timezone VARCHAR(50),
    -- airport specifications
    Elevation_Feet INT,
    Terminal_Count INT,
    Opening_Date DATE,
    Is_International BIT,
    Is_Active BIT DEFAULT 1,
);



DROP TABLE IF EXISTS SA_Route;
GO
CREATE TABLE SA_Route
(
    Route_ID INT,
    Route_Code VARCHAR(20),
    Route_Name VARCHAR(100),
    -- route information
    Origin_Airport_Code VARCHAR(10),
    Destination_Airport_Code VARCHAR(10),
    Distance_KM INT,
    Flight_Duration_Minutes INT,
    Is_International BIT,
    Is_Active BIT DEFAULT 1
);



DROP TABLE IF EXISTS SA_Loyalty_Tier;
GO
CREATE TABLE SA_Loyalty_Tier
(
    Loyalty_Tier_ID INT,
    Tier_Name VARCHAR(50),
    Benefits NVARCHAR(1000),
    Required_Points INT,
    Is_Active BIT DEFAULT 1
);



DROP TABLE IF EXISTS SA_Customer;
GO
CREATE TABLE SA_Customer
(
    Customer_ID INT,
    Passport_Code VARCHAR(20),
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone_Number VARCHAR(20) UNIQUE,
    Gender CHAR(1),
    Birth_Date DATE,
    -- address information
    Nationality VARCHAR(50),
    City VARCHAR(50),
    Country VARCHAR(50),
    Address VARCHAR(200),
    Postal_Code VARCHAR(20),
    Preferred_Language VARCHAR(30),
    -- loyalty program information
    Loyalty_Tier_ID INT,
    Loyalty_Points INT DEFAULT 0,
    Loyalty_Change_Date DATE,
    -- account information
    Is_Active BIT DEFAULT 1,
    Last_Login_Date DATETIME,
    Created_At DATETIME DEFAULT SYSDATETIME(),
    Updated_At DATETIME DEFAULT SYSDATETIME()
);



DROP TABLE IF EXISTS SA_Class;
GO
CREATE TABLE SA_Class
(
    Class_ID INT,
    Class_Code VARCHAR(10) NOT NULL,
    Class_Name VARCHAR(50) NOT NULL,
    Description NVARCHAR(500),
    -- Pricing information
    Base_Price_Multiplier DECIMAL(4,2) NOT NULL,
    Change_Fee_Amount DECIMAL(10,2),
    Cancellation_Fee_Amount DECIMAL(10,2),
    -- Passenger benefits
    Baggage_Allowance_KG DECIMAL(5,2) NOT NULL,
    Carry_On_Allowance_KG DECIMAL(5,2) NOT NULL,
    -- Status information
    Is_Active BIT DEFAULT 1 NOT NULL,
);



DROP TABLE IF EXISTS SA_Payment_Method;
GO
CREATE TABLE SA_Payment_Method
(
    -- payment method information
    Payment_Method_ID INT,
    Method_Name VARCHAR(50),
    Description NVARCHAR(200),
    -- provider information
    Provider_Name VARCHAR(50),
    Processing_Fee DECIMAL(5,2),
    Currency VARCHAR(3),
    Is_Active BIT DEFAULT 1
);



DROP TABLE IF EXISTS SA_Cargo_Type;
GO
CREATE TABLE SA_Cargo_Type
(
    Cargo_Type_ID INT,
    Type_Name VARCHAR(100) NOT NULL,
    Description NVARCHAR(1000),
    Is_Hazardous BIT NOT NULL DEFAULT 0,
    Max_Weight_KG DECIMAL(10,2),
);



DROP TABLE IF EXISTS SA_Employee;
GO
CREATE TABLE SA_Employee
(
    Employee_ID INT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100),
    Phone_Number VARCHAR(20),
    Birth_Date DATE,
    Hire_Date DATE,
    Exit_Date DATE NULL,
    Emergency_Contact VARCHAR(100) NULL
);



DROP TABLE IF EXISTS SA_Crew_Role_Type;
GO
CREATE TABLE SA_Crew_Role_Type
(
    Role_Type_ID INT,
    Role_Type_Name VARCHAR(50) NOT NULL,
    Description NVARCHAR(500),
);



DROP TABLE IF EXISTS SA_Crew_Role;
GO
CREATE TABLE SA_Crew_Role
(
    Crew_Role_ID INT,
    Crew_Role_Type_ID INT NOT NULL,
    Role_Name VARCHAR(50) NOT NULL,
    Description NVARCHAR(500),
    Basic_Fee_Per_Hour DECIMAL(10,2) NOT NULL
);



DROP TABLE IF EXISTS SA_Crew;
GO
CREATE TABLE SA_Crew
(
    Crew_ID INT,
    Employee_ID INT,
    Crew_Role_Type_ID INT,
    Certification_Level VARCHAR(50),
    Nationality VARCHAR(50),
    License_Number VARCHAR(30),
    License_Expiry_Date DATE,
    Training_Hours INT,
);



DROP TABLE IF EXISTS SA_Technician;
GO
CREATE TABLE SA_Technician
(
    Technician_ID INT,
    Employee_ID INT,
    Specialty VARCHAR(100),
    Certification_Level VARCHAR(50),
    License_Number VARCHAR(30),
    License_Expiry_Date DATE,
    Training_Hours INT,
    Years_Experience INT,
    Supervisor_ID INT NULL,
);



DROP TABLE IF EXISTS SA_Maintenance_Type;
GO
CREATE TABLE SA_Maintenance_Type
(
    Maintenance_Type_ID INT,
    Type_Name VARCHAR(100),
    Issue_Description NVARCHAR(2000),
    Resolution_Notes NVARCHAR(2000),
    Parts_Replace NVARCHAR(1000),
    Tools_Required NVARCHAR(1000),
    Estimated_Cost DECIMAL(15,2),
    Estimated_Duration_Hours INT,
    FAA_Required BIT
);



DROP TABLE IF EXISTS SA_Flight_Status;
GO
CREATE TABLE SA_Flight_Status
(
    Flight_Status_ID INT,
    Status_Name VARCHAR(50),
    Description NVARCHAR(200),
);



DROP TABLE IF EXISTS SA_Flight;
GO
CREATE TABLE SA_Flight
(
    -- flight information
    Flight_ID INT,
    Flight_Number VARCHAR(10),
    Flight_Date DATE,
    -- route information
    Aircraft_ID INT,
    Route_ID INT,
    Scheduled_Departure DATETIME,
    Scheduled_Arrival DATETIME,
    Actual_Departure DATETIME,
    Actual_Arrival DATETIME,
    Passenger_Count INT,
    Revenue DECIMAL(15,2),
    Fuel_Cost DECIMAL(15,2),
    Service_Cost DECIMAL(15,2),
    Flight_Status_ID INT
);



DROP TABLE IF EXISTS SA_Booking_Cancellation_Reason;
GO
CREATE TABLE SA_Booking_Cancellation_Reason
(
    Cancellation_ID INT,
    Reason NVARCHAR(200),
    Description NVARCHAR(1000)
);



DROP TABLE IF EXISTS SA_Ticket_Status;
GO
CREATE TABLE SA_Ticket_Status
(
    Status_ID INT,
    Name VARCHAR(50),
    Description NVARCHAR(1000)
);



DROP TABLE IF EXISTS SA_Ticket;
GO
CREATE TABLE SA_Ticket
(
    Ticket_ID INT,
    Flight_ID INT,
    Class_ID INT,
    Ticket_Status_ID INT,
    Price DECIMAL(10,2),
    Discount DECIMAL(10,2),
    Seat_Number VARCHAR(10),
);



DROP TABLE IF EXISTS SA_Booking;
GO
CREATE TABLE SA_Booking
(
    Booking_ID INT,
    Ticket_ID INT,
    Customer_ID INT,
    Payment_Method_ID INT,
    Booking_Date DATETIME,
    Total_Amount DECIMAL(10,2),
    Cancellation_Reason_ID INT,
    Cancellation_Fee DECIMAL(10,2),
    Created_At DATETIME2 DEFAULT SYSDATETIME(),
    Updated_At DATETIME2 DEFAULT SYSDATETIME(),
);



DROP TABLE IF EXISTS SA_Maintenance;
GO
CREATE TABLE SA_Maintenance
(
    Maintenance_ID INT,
    Aircraft_ID INT NOT NULL,
    Airport_Code VARCHAR(10),
    Maintenance_Type_ID INT NOT NULL,
    Supervise_Technician_ID INT NOT NULL,
    Maintenance_Start_Date DATETIME NOT NULL,
    Maintenance_End_Date DATETIME NULL,
    Part_Cost DECIMAL(10,2),
    Technician_Fee DECIMAL(10,2),
    Technician_Count INT,
);



DROP TABLE IF EXISTS SA_Feedback;
GO
CREATE TABLE SA_Feedback
(
    Feedback_ID INT,
    Ticket_ID INT,
    Flight_ID INT,
    Feedback_Date DATE,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment_Text NVARCHAR(2000),
    Analyzed_Text_Feedback INT CHECK (Analyzed_Text_Feedback BETWEEN -5 AND 5),
    --UNIQUE (Ticket_ID, Flight_ID),
);



DROP TABLE IF EXISTS SA_Cargo;
GO
CREATE TABLE SA_Cargo
(
    Cargo_ID INT,
    Ticket_ID INT,
    Flight_ID INT,
    Cargo_Type_ID INT,
    Weight_KG DECIMAL(10,2),
    Volume_CM3 DECIMAL(10,2),
    Declared_Value DECIMAL(10,2),
    Is_Lost BIT,
    Is_Damaged BIT,
    Is_Insure BIT,
    Cargo_Delivery_Date DATE,
);



DROP TABLE IF EXISTS SA_Flight_Crew;
GO
CREATE TABLE SA_Flight_Crew
(
    Flight_ID INT,
    Crew_ID INT,
    Crew_Role_ID INT,
    Assignment_Date DATE,
    Duration_Hours DECIMAL(6,2),
    Hourly_Fee DECIMAL(8,2),
    Bonus DECIMAL(10,2),
    Start_Time DATETIME,
    End_Time DATETIME,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
);