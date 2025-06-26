-- this file is Storage Area Codes BackUp
-- using the file to Create SA-DB
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
    Aircraft_ID INT,
    Registration_Number VARCHAR(25),
    Model VARCHAR(55),
    Manufacturer VARCHAR(55),
    Manufacture_Date DATE,
    Engine_Type VARCHAR(55),
    Max_Range_KM INT,
    Passenger_Capacity INT,
    Fuel_Capacity_Liters DECIMAL(12,2),
    Cargo_Capacity_KG INT,
    Is_Active BIT,
);



DROP TABLE IF EXISTS SA_Airport;
GO
CREATE TABLE SA_Airport
(
    Airport_Code VARCHAR(15),
    Airport_Name VARCHAR(110),
    IATA_Code CHAR(5),
    ICAO_Code CHAR(6),
    City VARCHAR(55),
    Country VARCHAR(55),
    Latitude DECIMAL(12,6),
    Longitude DECIMAL(12,6),
    Timezone VARCHAR(55),
    Elevation_Feet INT,
    Terminal_Count INT,
    Opening_Date DATE,
    Is_International BIT,
    Is_Active BIT,
);



DROP TABLE IF EXISTS SA_Route;
GO
CREATE TABLE SA_Route
(
    Route_ID INT,
    Route_Code VARCHAR(25),
    Route_Name VARCHAR(110),
    Origin_Airport_Code VARCHAR(15),
    Destination_Airport_Code VARCHAR(15),
    Distance_KM INT,
    Flight_Duration_Minutes INT,
    Is_International BIT,
    Is_Active BIT,
);



DROP TABLE IF EXISTS SA_Loyalty_Tier;
GO
CREATE TABLE SA_Loyalty_Tier
(
    Loyalty_Tier_ID INT,
    Tier_Name VARCHAR(55),
    Benefits NVARCHAR(1100),
    Required_Points INT,
    Is_Active BIT,
);



DROP TABLE IF EXISTS SA_Customer;
GO
CREATE TABLE SA_Customer
(
    Customer_ID INT,
    Passport_Code VARCHAR(25),
    First_Name VARCHAR(55),
    Last_Name VARCHAR(55),
    Email VARCHAR(110),
    Phone_Number VARCHAR(20),
    Gender CHAR(1),
    Birth_Date DATE,
    Nationality VARCHAR(55),
    City VARCHAR(55),
    Country VARCHAR(55),
    Address VARCHAR(220),
    Postal_Code VARCHAR(25),
    Preferred_Language VARCHAR(35),
    Loyalty_Tier_ID INT,
    Loyalty_Points INT,
    Loyalty_Change_Date DATE,
    Is_Active BIT,
    Last_Login_Date DATETIME,
    Created_At DATETIME,
    Updated_At DATETIME
);



DROP TABLE IF EXISTS SA_Class;
GO
CREATE TABLE SA_Class
(
    Class_ID INT,
    Class_Code VARCHAR(15),
    Class_Name VARCHAR(55),
    Description NVARCHAR(550),
    Base_Price_Multiplier DECIMAL(6,2),
    Change_Fee_Amount DECIMAL(12,2),
    Cancellation_Fee_Amount DECIMAL(12,2),
    Baggage_Allowance_KG DECIMAL(8,2),
    Carry_On_Allowance_KG DECIMAL(8,2),
    Is_Active BIT,
);



DROP TABLE IF EXISTS SA_Payment_Method;
GO
CREATE TABLE SA_Payment_Method
(
    Payment_Method_ID INT,
    Method_Name VARCHAR(55),
    Description NVARCHAR(250),
    Provider_Name VARCHAR(55),
    Processing_Fee DECIMAL(8,2),
    Currency VARCHAR(5),
    Is_Active BIT
);



DROP TABLE IF EXISTS SA_Cargo_Type;
GO
CREATE TABLE SA_Cargo_Type
(
    Cargo_Type_ID INT,
    Type_Name VARCHAR(110),
    Description NVARCHAR(1100),
    Is_Hazardous BIT,
    Max_Weight_KG DECIMAL(12,2),
);



DROP TABLE IF EXISTS SA_Employee;
GO
CREATE TABLE SA_Employee
(
    Employee_ID INT,
    First_Name VARCHAR(55),
    Last_Name VARCHAR(55),
    Email VARCHAR(110),
    Phone_Number VARCHAR(25),
    Birth_Date DATE,
    Hire_Date DATE,
    Exit_Date DATE,
    Emergency_Contact VARCHAR(110),
);



DROP TABLE IF EXISTS SA_Crew_Role_Type;
GO
CREATE TABLE SA_Crew_Role_Type
(
    Role_Type_ID INT,
    Role_Type_Name VARCHAR(55),
    Description NVARCHAR(550),
);



DROP TABLE IF EXISTS SA_Crew_Role;
GO
CREATE TABLE SA_Crew_Role
(
    Crew_Role_ID INT,
    Crew_Role_Type_ID INT,
    Role_Name VARCHAR(55),
    Description NVARCHAR(550),
    Basic_Fee_Per_Hour DECIMAL(12,2)
);



DROP TABLE IF EXISTS SA_Crew;
GO
CREATE TABLE SA_Crew
(
    Crew_ID INT,
    Employee_ID INT,
    Crew_Role_Type_ID INT,
    Certification_Level VARCHAR(55),
    Nationality VARCHAR(55),
    License_Number VARCHAR(35),
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
    Type_Name VARCHAR(110),
    Issue_Description NVARCHAR(2200),
    Resolution_Notes NVARCHAR(2200),
    Parts_Replace NVARCHAR(1100),
    Tools_Required NVARCHAR(1100),
    Estimated_Cost DECIMAL(18,2),
    Estimated_Duration_Hours INT,
    FAA_Required BIT
);



DROP TABLE IF EXISTS SA_Flight_Status;
GO
CREATE TABLE SA_Flight_Status
(
    Flight_Status_ID INT,
    Status_Name VARCHAR(55),
    Description NVARCHAR(220),
);



DROP TABLE IF EXISTS SA_Flight;
GO
CREATE TABLE SA_Flight
(
    Flight_ID INT,
    Flight_Number VARCHAR(15),
    Flight_Date DATE,
    Aircraft_ID INT,
    Route_ID INT,
    Scheduled_Departure DATETIME,
    Scheduled_Arrival DATETIME,
    Actual_Departure DATETIME,
    Actual_Arrival DATETIME,
    Passenger_Count INT,
    Revenue DECIMAL(18,2),
    Fuel_Cost DECIMAL(18,2),
    Service_Cost DECIMAL(18,2),
    Flight_Status_ID INT
);



DROP TABLE IF EXISTS SA_Booking_Cancellation_Reason;
GO
CREATE TABLE SA_Booking_Cancellation_Reason
(
    Cancellation_ID INT,
    Reason NVARCHAR(220),
    Description NVARCHAR(1100)
);



DROP TABLE IF EXISTS SA_Ticket_Status;
GO
CREATE TABLE SA_Ticket_Status
(
    Status_ID INT,
    Name VARCHAR(55),
    Description NVARCHAR(1100)
);



DROP TABLE IF EXISTS SA_Ticket;
GO
CREATE TABLE SA_Ticket
(
    Ticket_ID INT,
    Flight_ID INT,
    Class_ID INT,
    Ticket_Status_ID INT,
    Price DECIMAL(12,2),
    Discount DECIMAL(12,2),
    Seat_Number VARCHAR(15),
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
    Total_Amount DECIMAL(12,2),
    Cancellation_Reason_ID INT,
    Cancellation_Fee DECIMAL(12,2),
    Created_At DATETIME2,
    Updated_At DATETIME2,
);



DROP TABLE IF EXISTS SA_Maintenance;
GO
CREATE TABLE SA_Maintenance
(
    Maintenance_ID INT,
    Aircraft_ID INT,
    Airport_Code VARCHAR(15),
    Maintenance_Type_ID INT,
    Supervise_Technician_ID INT,
    Maintenance_Start_Date DATETIME,
    Maintenance_End_Date DATETIME,
    Part_Cost DECIMAL(12,2),
    Technician_Fee DECIMAL(12,2),
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
    Rating INT,
    Comment_Text NVARCHAR(2200),
    Analyzed_Text_Feedback INT,
);



DROP TABLE IF EXISTS SA_Cargo_Status;
GO
CREATE TABLE Cargo_Status
(
    Cargo_Status_ID INT,
    Status_Name VARCHAR(55),
    Description NVARCHAR(220),
);



DROP TABLE IF EXISTS SA_Cargo;
GO
CREATE TABLE SA_Cargo
(
    Cargo_ID INT,
    Cargo_Status_ID INT,
    Ticket_ID INT,
    Flight_ID INT,
    Cargo_Type_ID INT,
    Weight_KG DECIMAL(12,2),
    Volume_CM3 DECIMAL(12,2),
    Declared_Value DECIMAL(12,2),
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
    Duration_Hours DECIMAL(8,2),
    Hourly_Fee DECIMAL(10,2),
    Bonus DECIMAL(12,2),
    Start_Time DATETIME,
    End_Time DATETIME,
    Rating INT,
);
