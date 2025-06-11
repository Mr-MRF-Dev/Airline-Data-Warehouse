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



-- ==========================================================
-- ==================    All Dimensions    ==================
-- ==========================================================



-- Time Dim
-- all fields using SCD 1
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



























-- ========== Cancellation Reason Dimension ==========
CREATE TABLE Dim_Cancellation_Reason
(
    Cancellation_Reason_ID INT PRIMARY KEY,
    Reason_Code VARCHAR(20),
    Reason_Description NVARCHAR(255),
    Category VARCHAR(50),
    Is_Temporary BIT
);


-- ========== Flight Dimension (SCD1) ==========
CREATE TABLE Dim_Flight
(
    Flight_SK INT PRIMARY KEY,
    Flight_ID INT,
    Flight_Number VARCHAR(10),
    Route_SK INT,
    Schedule_SK INT
);

-- Technician (SCD1)
CREATE TABLE Dim_Technician
(
    Technician_ID INT PRIMARY KEY,
    Employee_ID INT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100),
    Phone_Number VARCHAR(20),
    Birth_Date DATE,
    Hire_Date DATE,
    Exit_Date DATE NULL,
    Is_Active BIT DEFAULT 1,
    Emergency_Contact VARCHAR(100) NULL,
    Specialty VARCHAR(100),
    Employee_ID INT,
    Specialty VARCHAR(100),
    Certification_Level VARCHAR(50),
    License_Number VARCHAR(30),
    License_Expiry_Date DATE,
    Training_Hours INT,
    Years_Experience INT,
    Supervisor_ID INT NULL
);

-- Maintenance Type (SCD1)
CREATE TABLE Dim_Maintenance_Type
(
    Maintenance_Type_ID INT PRIMARY KEY,
    Type_Name VARCHAR(100),
    Description NVARCHAR(1000),
    Tools_Required NVARCHAR(1000)
);

-- Customer (SCD2)
CREATE TABLE Dim_Customer
(
    Customer_SK INT PRIMARY KEY,
    Customer_ID INT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100),
    Gender CHAR(1),
    Birth_Date DATE,
    Country VARCHAR(50),
    Loyalty_Tier VARCHAR(50),
    Entry_Date DATE,
    Expiry_Date DATE,
    Is_Current BIT
);

-- Class (SCD2)
CREATE TABLE Dim_Class
(
    Class_SK INT PRIMARY KEY,
    Class_ID INT,
    Class_Name VARCHAR(50),
    Services NVARCHAR(1000),
    Entry_Date DATE,
    Expiry_Date DATE,
    Is_Current BIT
);

-- Payment Method (SCD1)
CREATE TABLE Dim_Payment_Method
(
    Payment_Method_ID INT PRIMARY KEY,
    Method_Name VARCHAR(50),
    Provider_Name VARCHAR(50)
);

-- Fact: Flight Operations (Transactional)
CREATE TABLE Fact_Flight_Operations
(
    Flight_SK INT PRIMARY KEY,
    Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
    Route_SK INT REFERENCES Dim_Route(Route_SK),
    Schedule_SK INT REFERENCES Dim_Schedule(Schedule_SK),
    Departure_Airport_SK INT REFERENCES Dim_Airport(Airport_SK),
    Arrival_Airport_SK INT REFERENCES Dim_Airport(Airport_SK),
    Departure_Delay_Minutes INT,
    Arrival_Delay_Minutes INT,
    Passenger_Count INT,
    Revenue DECIMAL(10,2),
    Cancelled BIT,
    Cancellation_Reason_ID INT REFERENCES Dim_Cancellation_Reason(Cancellation_Reason_ID),
    CONSTRAINT FK_Fact_Flight_Operations_Flight_SK FOREIGN KEY (Flight_SK) REFERENCES Dim_Flight(Flight_SK)
);

-- Fact: Flight Snapshot (Periodic)
CREATE TABLE Fact_Flight_Snapshot_Monthly
(
    Snapshot_ID INT PRIMARY KEY,
    Snapshot_Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
    Route_SK INT REFERENCES Dim_Route(Route_SK),
    Total_Flights INT,
    Avg_Passenger_Count INT,
    Total_Revenue DECIMAL(12,2),
    Avg_Delay_Minutes DECIMAL(10,2)
);

-- Fact: Flight Lifecycle (Accumulating)
CREATE TABLE Fact_Flight_Lifecycle
(
    Flight_SK INT PRIMARY KEY,
    Scheduled_Departure_Date DATE,
    Actual_Departure_Date DATE,
    Actual_Arrival_Date DATE,
    Cancellation_Date DATE,
    Final_Status VARCHAR(30),
    Total_Duration_Minutes INT,
    Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
    Route_SK INT REFERENCES Dim_Route(Route_SK),
    Schedule_SK INT REFERENCES Dim_Schedule(Schedule_SK),
    CONSTRAINT FK_Fact_Flight_Lifecycle_Flight_SK FOREIGN KEY (Flight_SK) REFERENCES Dim_Flight(Flight_SK)
);

-- Factless: Route Execution
CREATE TABLE Fact_Route_Execution
(
    Route_SK INT REFERENCES Dim_Route(Route_SK),
    Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
    PRIMARY KEY (Route_SK, Date_Key, Aircraft_SK)
);

-- Fact: Ticket Sales (Transactional)
CREATE TABLE Fact_Ticket_Sales
(
    Ticket_ID INT PRIMARY KEY,
    Customer_SK INT REFERENCES Dim_Customer(Customer_SK),
    Flight_SK INT REFERENCES Dim_Flight(Flight_SK),
    Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    Class_SK INT REFERENCES Dim_Class(Class_SK),
    Payment_Method_ID INT REFERENCES Dim_Payment_Method(Payment_Method_ID),
    Price DECIMAL(10,2),
    Discount DECIMAL(10,2),
    Final_Amount DECIMAL(10,2),
    Is_Refunded BIT
);

-- Fact: Ticket Sales Snapshot (Periodic)
CREATE TABLE Fact_Ticket_Sales_Snapshot
(
    Snapshot_ID INT PRIMARY KEY,
    Snapshot_Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    Class_SK INT REFERENCES Dim_Class(Class_SK),
    Total_Tickets_Sold INT,
    Total_Revenue DECIMAL(12,2),
    Avg_Discount DECIMAL(10,2)
);

-- Fact: Customer Lifecycle (Accumulating)
CREATE TABLE Fact_Customer_Lifecycle
(
    Customer_SK INT PRIMARY KEY,
    Signup_Date DATE,
    First_Booking_Date DATE,
    Last_Booking_Date DATE,
    Loyalty_Change_Date DATE,
    Lifetime_Value DECIMAL(12,2),
    Total_Tickets INT,
    Avg_Spend_Per_Ticket DECIMAL(10,2),
    CONSTRAINT FK_Fact_Customer_Lifecycle_Customer_SK FOREIGN KEY (Customer_SK) REFERENCES Dim_Customer(Customer_SK)
);

-- Factless: Customer Feedback
CREATE TABLE Fact_Customer_Feedback
(
    Customer_SK INT REFERENCES Dim_Customer(Customer_SK),
    Flight_SK INT REFERENCES Dim_Flight(Flight_SK),
    Feedback_Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    Rating INT,
    Comment_Text NVARCHAR(2000),
    PRIMARY KEY (Customer_SK, Flight_SK, Feedback_Date_Key)
);

-- Fact: Maintenance Log (Transactional)
CREATE TABLE Fact_Maintenance_Log
(
    Maintenance_ID INT PRIMARY KEY,
    Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
    Maintenance_Type_SK INT REFERENCES Dim_Maintenance_Type(Maintenance_Type_SK),
    Technician_ID INT REFERENCES Dim_Technician(Technician_ID),
    Start_Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    End_Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    Start_Date DATE,
    End_Date DATE,
    Duration_Hours INT,
    Cost DECIMAL(10,2),
    Issue_Description NVARCHAR(2000)
);

-- Fact: Maintenance Snapshot (Periodic)
CREATE TABLE Fact_Maintenance_Snapshot_Monthly
(
    Snapshot_ID INT PRIMARY KEY,
    Snapshot_Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
    Total_Maintenances INT,
    Total_Cost DECIMAL(12,2),
    Avg_Downtime DECIMAL(10,2),
    Most_Common_Issue NVARCHAR(200)
);

-- Fact: Aircraft Lifecycle (Accumulating)
CREATE TABLE Fact_Aircraft_Lifecycle
(
    Aircraft_SK INT PRIMARY KEY,
    Manufacture_Date DATE,
    First_Service_Date DATE,
    Last_Maintenance_Date DATE,
    Retirement_Date DATE,
    Total_Flight_Hours INT,
    Total_Downtime INT,
    Total_Maintenance_Cost DECIMAL(12,2),
    CONSTRAINT FK_Fact_Aircraft_Lifecycle_Aircraft_SK FOREIGN KEY (Aircraft_SK) REFERENCES Dim_Aircraft(Aircraft_SK)
);

-- Factless: Health Checks
CREATE TABLE Fact_Health_Checks
(
    Aircraft_SK INT REFERENCES Dim_Aircraft(Aircraft_SK),
    Date_Key INT REFERENCES Dim_DateTimeTime(Date_Key),
    Technician_ID INT REFERENCES Dim_Technician(Technician_ID),
    Health_Score INT,
    Passed_Flag BIT,
    Notes NVARCHAR(1000),
    PRIMARY KEY (Aircraft_SK, Date_Key, Technician_ID)
);