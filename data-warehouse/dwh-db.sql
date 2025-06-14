-- this file is data ware house, have facts and dimensions
GO
USE [master];
IF DB_ID('AirlineDWH') IS NOT NULL
BEGIN
    ALTER DATABASE AirlineDWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AirlineDWH;
END;
GO
CREATE DATABASE AirlineDWH;
GO
USE AirlineDWH;
GO



GO
-- ==========================================================
-- ==================    All Dimensions    ==================
-- ==========================================================
GO



-- Time Dim
-- all fields using SCD 1
DROP TABLE IF EXISTS Dim_DateTime;
GO
CREATE TABLE Dim_DateTime
(
    DateTime_ID DATETIME PRIMARY KEY,
    -- Date
    Full_Date_Alternate_Key DATE,
    Persian_Full_Date_Alternate_Key VARCHAR(10),
    Day_Number_Of_Week INT,
    Persian_Day_Number_Of_Week INT,
    English_Day_Name_Of_Week VARCHAR(10),
    Persian_Day_Name_Of_Week VARCHAR(10),
    Day_Number_Of_Month INT,
    Persian_Day_Number_Of_Month INT,
    Day_Number_Of_Year INT,
    Persian_Day_Number_Of_Year INT,
    Week_Number_Of_Year INT,
    Persian_Week_Number_Of_Year INT,
    English_Month_Name VARCHAR(10),
    Persian_Month_Name VARCHAR(10),
    Month_Number_Of_Year INT,
    Persian_Month_Number_Of_Year INT,
    Calendar_Quarter INT,
    Persian_Calendar_Quarter INT,
    Calendar_Year INT,
    Persian_Calendar_Year INT,
    Calendar_Semester INT,
    Persian_Calendar_Semester INT,
    -- Time
    Full_GMT_Time_Alternate_Key TIME,
    Full_IR_Time_Alternate_Key TIME,
    GMT_Hour_Of_Time INT,
    IR_Hour_Of_Time INT,
    GMT_Minute_Of_Time INT,
    IR_Minute_Of_Time INT
);



-- Aircraft Dim
-- all fields using SCD Type 1 + one field SCD 2
DROP TABLE IF EXISTS Dim_Aircraft;
GO
CREATE TABLE Dim_Aircraft
(
    -- aircraft id and registration
    Aircraft_SK INT PRIMARY KEY,
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
    -- SCD 2, track the aircraft activity
    Is_Active BIT,
    Effective_Start_Date DATE,
    Effective_End_Date DATE,
    Is_Current BIT DEFAULT 1,
    -- END of SCD 2
);



-- Airport Dim
-- all fields using SCD Type 1 + one field SCD 2
DROP TABLE IF EXISTS Dim_Airport;
GO
CREATE TABLE Dim_Airport
(
    -- airport information
    Airport_SK INT PRIMARY KEY,
    Airport_ID INT,
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
    -- SCD 2, track the airport activity
    Is_Active BIT,
    Effective_Start_Date DATE,
    Effective_End_Date DATE,
    Is_Current BIT DEFAULT 1,
    -- END of SCD 2
);



-- Route Dim
-- all fields using SCD Type 1 + one field SCD 2
DROP TABLE IF EXISTS Dim_Route;
GO
CREATE TABLE Dim_Route
(
    Route_SK INT PRIMARY KEY,
    Route_ID INT,
    Route_Code VARCHAR(20),
    Route_Name VARCHAR(100),
    -- route information
    Origin_Airport_ID INT,
    Destination_Airport_ID INT,
    Origin_Airport_Name VARCHAR(10),
    Destination_Airport_Name VARCHAR(10),
    Distance_KM INT,
    Flight_Duration_Minutes INT,
    Is_International BIT,
    -- SCD 2, track the route activity
    Is_Active BIT,
    Effective_Start_Date DATE,
    Effective_End_Date DATE,
    Is_Current BIT DEFAULT 1,
    -- END of SCD 2
);



-- the Dim Customer Loyalty Tier Dim
-- all fields using SCD 1 + one field SCD 2
DROP TABLE IF EXISTS Dim_Customer_Loyalty_Tier;
GO
CREATE TABLE Dim_Customer_Loyalty_Tier
(
    Loyalty_Tier_SK INT PRIMARY KEY,
    Loyalty_Tier_ID INT,
    Tier_Name VARCHAR(50),
    Benefits NVARCHAR(1000),
    Required_Points INT,
    -- SCD 2, track the loyalty tier activity
    Is_Active BIT,
    Effective_Start_Date DATE,
    Effective_End_Date DATE,
    Is_Current BIT DEFAULT 1,
    -- END of SCD 2
);



-- the Customer Dim
-- all fields using SCD 1 / SCD 2
DROP TABLE IF EXISTS Dim_Customer;
GO
CREATE TABLE Dim_Customer
(
    Customer_SK INT PRIMARY KEY,
    Customer_ID INT,
    -- Passport Code is SCD 2
    Passport_Code VARCHAR(20),
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100),
    -- Phone Number is SCD 2
    Phone_Number VARCHAR(20),
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
    -- Loyalty Tier is SCD 2
    Loyalty_Tier_ID INT,
    Loyalty_Tier_NAME VARCHAR(50),
    Loyalty_Change_Date DATE,
    -- End of SCD 2
    Loyalty_Points INT,
    -- account information
    -- is Active is SCD 2
    Is_Active BIT,
    Last_Login_Date DATETIME,
    Created_At DATETIME,
    -- Updated At is SCD 2
    Updated_At DATETIME,

    -- SCD Fields
    Effective_Start_Date DATE,
    Effective_End_Date DATE,
    Passport_Code_Change_Bit BIT DEFAULT 0,
    Phone_Number_Change_Bit BIT DEFAULT 0,
    Loyalty_Tier_Change_Bit BIT DEFAULT 0,
    Is_Active_Change_Bit BIT DEFAULT 0,
    Updated_At_Change_Bit BIT DEFAULT 0,
    Is_Current BIT DEFAULT 1
);



-- the Ticket Class Dim
-- all fields using SCD 1 + one field SCD 2
DROP TABLE IF EXISTS Dim_Ticket_Class;
GO
CREATE TABLE Dim_Ticket_Class
(
    Class_SK INT PRIMARY KEY,
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
    -- SCD 2, track the ticket class activity
    Is_Active BIT,
    Effective_Start_Date DATE,
    Effective_End_Date DATE,
    Is_Current BIT DEFAULT 1,
    -- END of SCD 2
);



-- the Payment Method Dim
-- all fields using SCD 1 + one field SCD 2
DROP TABLE IF EXISTS Dim_Payment_Method;
GO
CREATE TABLE Dim_Payment_Method
(
    -- payment method information
    Payment_Method_ID INT PRIMARY KEY,
    Method_Name VARCHAR(50),
    Description NVARCHAR(200),
    -- provider information
    Provider_Name VARCHAR(50),
    Processing_Fee DECIMAL(5,2),
    Currency VARCHAR(3),
    -- SCD 2, track the  payment method activity
    Is_Active BIT,
    Effective_Start_Date DATE,
    Effective_End_Date DATE,
    Is_Current BIT DEFAULT 1,
    -- END of SCD 2
);



-- the Cargo Type Dim
-- all fields using SCD 1
DROP TABLE IF EXISTS Dim_Cargo_Type;
GO
CREATE TABLE Dim_Cargo_Type
(
    Cargo_Type_ID INT PRIMARY KEY,
    Type_Name VARCHAR(100) NOT NULL,
    Description NVARCHAR(1000),
    Is_Hazardous BIT NOT NULL DEFAULT 0,
    Max_Weight_KG DECIMAL(10,2),
);



-- the Cargo Type Dim
-- all fields using SCD 1 or SCD 0
DROP TABLE IF EXISTS Dim_Cargo_Status;
GO
CREATE TABLE Dim_Cargo_Status
(
    Cargo_Status_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description NVARCHAR(1000),
    -- Is_Lost, Is_Damaged, Is_Insure,
);



-- the Crew Role Dim - Hierarchical Crew Role
-- all fields using SCD 1
DROP TABLE IF EXISTS Dim_Crew_Role;
GO
CREATE TABLE Dim_Crew_Role
(
    Crew_Role_ID INT PRIMARY KEY,
    Role_Name VARCHAR(50) NOT NULL,
    Role_Description NVARCHAR(500),
    Basic_Fee_Per_Hour DECIMAL(10,2) NOT NULL,
    Role_Type_ID INT,
    Role_Type_Name VARCHAR(50) NOT NULL,
    Role_Type_Description NVARCHAR(500),
);



-- the Crew Dim
-- all fields using SCD 1 + two field SCD 3
DROP TABLE IF EXISTS Dim_Crew;
GO
CREATE TABLE Dim_Crew
(
    Crew_ID INT PRIMARY KEY,
    Employee_ID INT,
    Role_Type_ID INT,
    Role_Type_Name VARCHAR (50),
    -- information
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100),
    -- Phone Number is SCD 3
    Original_Phone_Number VARCHAR(20),
    Current_Phone_Number VARCHAR(20),
    Effective_Phone_Number DATE,
    -- end of Phone Number SCD 3
    Birth_Date DATE,
    Hire_Date DATE,
    Exit_Date DATE,
    -- Emergency Contact is SCD 3
    Original_Emergency_Contact VARCHAR(100),
    Current_Emergency_Contact VARCHAR(100),
    Effective_Emergency_Contact DATE,
    -- end of Emergency Contact SCD 3
    Certification_Level VARCHAR (50),
    Nationality VARCHAR (50),
    License_Number VARCHAR (30),
    License_Expiry_Date DATE,
    Training_Hours INT,
);



-- the Technician Dim
-- all fields using SCD 1 + two field SCD 3
DROP TABLE IF EXISTS Dim_Technician;
GO
CREATE TABLE Dim_Technician
(
    Technician_ID INT PRIMARY KEY,
    Employee_ID INT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100),
    -- Phone Number is SCD 3
    Original_Phone_Number VARCHAR(20),
    Current_Phone_Number VARCHAR(20),
    Effective_Phone_Number DATE,
    -- end of Phone Number SCD 3
    Birth_Date DATE,
    Hire_Date DATE,
    Exit_Date DATE,
    -- Emergency Contact is SCD 3
    Original_Emergency_Contact VARCHAR(100),
    Current_Emergency_Contact VARCHAR(100),
    Effective_Emergency_Contact DATE,
    -- end of Emergency Contact SCD 3
    Specialty VARCHAR(100),
    Certification_Level VARCHAR(50),
    License_Number VARCHAR(30),
    License_Expiry_Date DATE,
    Training_Hours INT,
    Years_Experience INT,
    Supervisor_ID INT,
    Supervisor_First_Name VARCHAR(50),
    Supervisor_Last_Name VARCHAR(50)
);



-- the Maintenance Type Dim
-- all fields using SCD 1
DROP TABLE IF EXISTS Dim_Maintenance_Type;
GO
CREATE TABLE Dim_Maintenance_Type
(
    Maintenance_Type_ID INT PRIMARY KEY,
    Type_Name VARCHAR(100),
    Description NVARCHAR(1000),
    Tools_Required NVARCHAR(1000),
    Estimated_Duration_Hours INT,
    FAA_Required BIT
);



-- the Flight Status Dim
-- all fields using SCD 1
DROP TABLE IF EXISTS Dim_Flight_Status;
GO
CREATE TABLE Dim_Flight_Status
(
    Flight_Status_ID INT PRIMARY KEY,
    Status_Name VARCHAR(50),
    Description NVARCHAR(200),
);



-- the Booking Cancellation Reason Dim
-- all fields using SCD 1
DROP TABLE IF EXISTS Dim_Booking_Cancellation_Reason;
GO
CREATE TABLE Dim_Booking_Cancellation_Reason
(
    Cancellation_ID INT PRIMARY KEY,
    Reason NVARCHAR(200),
    Description NVARCHAR(1000)
);



-- the Ticket Status Dim
-- all fields using SCD 1
DROP TABLE IF EXISTS Dim_Ticket_Status;
GO
CREATE TABLE Dim_Ticket_Status
(
    Status_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Description NVARCHAR(1000)
);



-- the Flight Dim
-- all fields using SCD 1
DROP TABLE IF EXISTS Dim_Flight;
GO
CREATE TABLE Dim_Flight
(
    -- flight information
    Flight_ID INT PRIMARY KEY,
    Flight_Number VARCHAR(10),
    Scheduled_Departure DATETIME,
    Scheduled_Arrival DATETIME,
    Actual_Departure DATETIME,
    Actual_Arrival DATETIME,
    -- route information
    Aircraft_ID INT,
    Aircraft_Model VARCHAR(50),
    Route_ID INT,
    Origin_Airport_Name VARCHAR(10),
    Destination_Airport_Name VARCHAR(10),
    -- flight primary crew information
    Flight_Crew_Captain_ID INT,
    Flight_Crew_Captain_Name VARCHAR(100),
    Flight_Crew_Copilot_ID INT,
    Flight_Crew_Copilot_Name VARCHAR(100),
    Flight_Crew_Senior_Attendant_ID INT,
    Flight_Crew_Senior_Attendant_Name VARCHAR(100),
    Flight_Crew_Security_ID INT,
    Flight_Crew_Security_Name VARCHAR(100),
    Flight_Status_ID INT,
    Flight_Status VARCHAR(50),
);



GO
-- ==========================================================
-- ================== Data Mart 1 ~ Flight ==================
-- ==========================================================
GO



-- Fact Flight Operations (Accumulating)
DROP TABLE IF EXISTS Fact_Accumulate_Flight_Operations;
GO
CREATE TABLE Fact_Accumulate_Flight_Operations
(
    Flight_ID INT REFERENCES Dim_Flight(Flight_ID),
    Aircraft_ID INT REFERENCES Dim_Aircraft(Aircraft_SK),
    Route_ID INT REFERENCES Dim_Route(Route_SK),
    Departure_Airport_ID INT REFERENCES Dim_Airport(Airport_SK),
    Arrival_Airport_ID INT REFERENCES Dim_Airport(Airport_SK),
    Flight_Status_ID INT REFERENCES Dim_Flight_Status(Flight_Status_ID),
    Scheduled_Departure DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Scheduled_Arrival DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Actual_Departure DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Actual_Arrival DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Departure_Delay_Minutes INT,
    Arrival_Delay_Minutes INT,
    Flight_Duration_Minutes INT,
    Revenue DECIMAL(15,2),
    Fuel_Cost DECIMAL(15,2),
    Crew_Cost DECIMAL(15,2),
    Service_Cost DECIMAL(15,2),
    Crew_Count INT,
    Passenger_Count INT,
);



-- Fact Crew Flight (Transactional)
DROP TABLE IF EXISTS Fact_Transaction_Crew_Flight_Assignment;
GO
CREATE TABLE Fact_Transaction_Crew_Flight_Assignment
(
    Flight_ID INT REFERENCES Dim_Flight(Flight_ID),
    Crew_ID INT REFERENCES Dim_Crew(Crew_ID),
    Crew_Role_ID INT REFERENCES Dim_Crew_Role(Crew_Role_ID),
    Start_Time DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    End_Time DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Duration_Hours DECIMAL(6,2),
    Hourly_Fee DECIMAL(8,2),
    Total_Fee DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    Total_Pay DECIMAL(10,2),
    Rating INT,
);



-- Fact Routing Flight Operations Snapshot (Periodic)
DROP TABLE IF EXISTS Fact_Periodic_Route_Flight_Snapshot_Monthly;
GO
CREATE TABLE Fact_Periodic_Route_Flight_Snapshot_Monthly
(
    DateTime_Key DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Route_ID INT REFERENCES Dim_Route(Route_SK),
    Departure_Airport_ID INT REFERENCES Dim_Airport(Airport_SK),
    Arrival_Airport_ID INT REFERENCES Dim_Airport(Airport_SK),
    Total_Flights_Count INT,
    Total_Departure_Delay_Minutes INT,
    Total_Arrival_Delay_Minutes INT,
    Total_Flight_Duration_Minutes INT,
    Total_Revenue DECIMAL(15,2),
    Total_Fuel_Cost DECIMAL(15,2),
    Total_Crew_Cost DECIMAL(15,2),
    Total_Service_Cost DECIMAL(15,2),
    Total_Crew_Count INT,
    Total_Passenger_Count INT
);



GO
-- ==========================================================
-- ================= Data Mart 2 ~ Customer =================
-- ==========================================================
GO



-- Fact: booking Ticket Sales (Transactional)
DROP TABLE IF EXISTS Fact_Transaction_Booking_Ticket;
GO
CREATE TABLE Fact_Transaction_Booking_Ticket
(
    Flight_ID INT REFERENCES Dim_Flight(Flight_ID),
    Ticket_Class_ID INT REFERENCES Dim_Ticket_Class(Class_SK),
    Ticket_Status_ID INT REFERENCES Dim_Ticket_Status(Status_ID),
    Customer_ID INT REFERENCES Dim_Customer(Customer_SK),
    Customer_Loyalty_Tier_ID INT REFERENCES Dim_Customer_Loyalty_Tier(Loyalty_Tier_SK),
    Payment_Method_ID INT REFERENCES Dim_Payment_Method(Payment_Method_ID),
    Cancellation_Reason_ID INT REFERENCES Dim_Booking_Cancellation_Reason(Cancellation_ID),
    Booking_Created_At DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Booking_Update_At DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Price DECIMAL(10,2),
    Discount DECIMAL(10,2),
    Final_Price DECIMAL(10,2),
    Cancellation_Fee DECIMAL(10,2),
    -- feedback information
    Feedback_Rating INT ,
    Analyzed_Text_Feedback INT,
    -- additional fields (not major & part of the fact table, just for saving the data)
    Ticket_ID INT,
    Booking_ID INT,
    Seat_Number VARCHAR(10),
);



-- Fact: Customer Cargo (Transactional)
DROP TABLE IF EXISTS Fact_Transaction_Customer_Cargo;
GO
CREATE TABLE Fact_Transaction_Customer_Cargo
(
    Flight_ID INT REFERENCES Dim_Flight(Flight_ID),
    Ticket_Class_ID INT REFERENCES Dim_Ticket_Class(Class_SK),
    Customer_ID INT REFERENCES Dim_Customer(Customer_SK),
    Customer_Loyalty_Tier_ID INT REFERENCES Dim_Customer_Loyalty_Tier(Loyalty_Tier_SK),
    Cargo_Type_ID INT REFERENCES Dim_Cargo_Type(Cargo_Type_ID),
    Cargo_Status_ID INT REFERENCES Dim_Cargo_Status(Cargo_Status_ID),
    Cargo_Delivery_Date DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Weight_KG DECIMAL(10,2),
    Volume_CM3 DECIMAL(10,2),
    Declared_Value DECIMAL(10,2),
);



-- Fact: Ticket Class Sales Daily Snapshot (Periodic)
DROP TABLE IF EXISTS Fact_Ticket_Class_Sales_Daily;
GO
CREATE TABLE Fact_Ticket_Class_Sales_Daily
(
    DateTime_Key DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Ticket_Class_ID INT REFERENCES Dim_Ticket_Class(Class_SK),
    Route_ID INT REFERENCES Dim_Route(Route_SK),
    Total_Tickets_Sold INT,
    Total_Price DECIMAL(10,2),
    Avg_Price DECIMAL(10,2),
    Avg_Discount DECIMAL(10,2),
    Avg_Final_Price DECIMAL(10,2),
    Avg_Cancellation_Fee DECIMAL(10,2),
    Total_Cancellation_Fee DECIMAL(10,2),
    -- feedback information
    Avg_Feedback_Rating DECIMAL(6,2),
    Avg_Analyzed_Text_Feedback DECIMAL(6,2),
);



-- Fact: Customer Lifecycle (Accumulating)
CREATE TABLE Fact_Accumulate_Customer_Lifecycle
(
    Customer_ID INT REFERENCES Dim_Customer(Customer_SK),
    Sign_up_Date DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    First_Booking_Date DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Last_Booking_Date DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Loyalty_Change_Date DATETIME REFERENCES Dim_DateTime(DateTime_ID),
    Total_Tickets_Booking INT,
    Total_Successfully_Flight INT,
    Total_Cancellation INT,
    Loyalty_Points INT,
    Total_Ticket_Price DECIMAL(10,2),
    Avg_Feedback_Rating DECIMAL(6,2),
    Total_Cancellation_Fee DECIMAL(10,2),
    Avg_Analyzed_Text_Feedback DECIMAL(6,2),
);



GO
-- ==========================================================
-- =============== Data Mart 3 ~ Maintenance ================
-- ==========================================================
GO







-- -- Fact: Maintenance Log (Transactional)
-- CREATE TABLE Fact_Maintenance_Log
-- (
--     Maintenance_ID INT PRIMARY KEY,
--     Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
--     Maintenance_Type_SK INT REFERENCES Dim_Maintenance_Type(Maintenance_Type_SK),
--     Technician_ID INT REFERENCES Dim_Technician(Technician_ID),
--     Start_Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
--     End_Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
--     Start_Date DATE,
--     End_Date DATE,
--     Duration_Hours INT,
--     Cost DECIMAL(10,2),
--     Issue_Description NVARCHAR(2000)
-- );

-- -- Fact: Maintenance Snapshot (Periodic)
-- CREATE TABLE Fact_Maintenance_Snapshot_Monthly
-- (
--     Snapshot_ID INT PRIMARY KEY,
--     Snapshot_Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
--     Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
--     Total_Maintenances INT,
--     Total_Cost DECIMAL(12,2),
--     Avg_Downtime DECIMAL(10,2),
--     Most_Common_Issue NVARCHAR(200)
-- );

-- -- Fact: Aircraft Lifecycle (Accumulating)
-- CREATE TABLE Fact_Aircraft_Lifecycle
-- (
--     Aircraft_SK INT PRIMARY KEY,
--     Manufacture_Date DATE,
--     First_Service_Date DATE,
--     Last_Maintenance_Date DATE,
--     Retirement_Date DATE,
--     Total_Flight_Hours INT,
--     Total_Downtime INT,
--     Total_Maintenance_Cost DECIMAL(12,2),
--     CONSTRAINT FK_Fact_Aircraft_Lifecycle_Aircraft_SK FOREIGN KEY (Aircraft_SK) REFERENCES Dim_Aircraft(Aircraft_SK)
-- );

-- -- Fact less: Health Checks
-- CREATE TABLE Fact_Health_Checks
-- (
--     Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
--     Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
--     Technician_ID INT REFERENCES Dim_Technician(Technician_ID),
--     Health_Score INT,
--     Passed_Flag BIT,
--     Notes NVARCHAR(1000),
--     PRIMARY KEY (Aircraft_SK, Date_Key, Technician_ID)
-- );