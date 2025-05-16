-- this is the source database for the airline data warehouse
CREATE DATABASE Airline_Source_DB;
USE Airline_Source_DB;



CREATE TABLE Aircraft
(
    Aircraft_ID INT PRIMARY KEY,
    Registration_Number VARCHAR(20),
    Model VARCHAR(50),
    Capacity INT,
    Manufacturer VARCHAR(50),
    Engine_Type VARCHAR(50),
    Status VARCHAR(30),
    Manufacture_Date DATE,
    Max_Range_KM INT,
    Fuel_Capacity_Liters DECIMAL(10,2),
    Wingspan_Meters DECIMAL(6,2)
);



CREATE TABLE Airport
(
    Airport_Code VARCHAR(10) PRIMARY KEY,
    Airport_Name VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(50),
    IATA_Code CHAR(3),
    ICAO_Code CHAR(4),
    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6),
    Elevation_Feet INT,
    Timezone VARCHAR(50),
    DST CHAR(1),
    Is_International BIT,
    Opening_Date DATE,
    Terminal_Count INT
);




CREATE TABLE Route
(
    Route_ID INT PRIMARY KEY,
    Origin_Airport_Code VARCHAR(10),
    Destination_Airport_Code VARCHAR(10),
    Distance_KM INT,
    Domestic_International VARCHAR(20),
    FOREIGN KEY (Origin_Airport_Code) REFERENCES Airport(Airport_Code),
    FOREIGN KEY (Destination_Airport_Code) REFERENCES Airport(Airport_Code)
);



CREATE TABLE Customer
(
    Customer_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone_Number VARCHAR(20),
    Gender CHAR(1),
    Birth_Date DATE,
    Country VARCHAR(50),
    City VARCHAR(50),
    Address VARCHAR(200),
    Postal_Code VARCHAR(20),
    Loyalty_Tier VARCHAR(50),
    Loyalty_Points INT DEFAULT 0,
    SignUp_Date DATE,
    Loyalty_Change_Date DATE,
    Last_Login_Date DATETIME,
    Preferred_Language VARCHAR(30),
    Is_Active BIT DEFAULT 1,
    Created_At DATETIME2 DEFAULT SYSDATETIME(),
    Updated_At DATETIME2 DEFAULT SYSDATETIME()
);



CREATE TABLE Class
(
    Class_ID INT PRIMARY KEY,
    Class_Name VARCHAR(50),
    Services NVARCHAR(1000),
    Price_Multiplier DECIMAL(4,2),
    Baggage_Allowance_KG DECIMAL(5,2),
    Seat_Pitch_CM INT,
    Priority_Boarding BIT DEFAULT 0,
    Lounge_Access BIT DEFAULT 0,
    Meal_Service_Level VARCHAR(50),
    Is_Active BIT DEFAULT 1
);



CREATE TABLE Payment_Method
(
    Payment_Method_ID INT PRIMARY KEY,
    Method_Name VARCHAR(50),
    Provider_Name VARCHAR(50),
    Processing_Fee DECIMAL(5,2),
    Currency VARCHAR(3),
    Is_Active BIT DEFAULT 1,
    Added_Date DATETIME DEFAULT GETDATE(),
    Security_Level VARCHAR(20),
    Description NVARCHAR(200)
);



CREATE TABLE Cargo_Type
(
    Cargo_Type_ID INT PRIMARY KEY,
    Type_Name VARCHAR(100),
    Description NVARCHAR(1000),
    Is_Hazardous BIT
);



CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100),
    Phone_Number VARCHAR(20),
    Birth_Date DATE,
    Hire_Date DATE,
    Exit_Date DATE NULL,
    Is_Active BIT DEFAULT 1,
    Emergency_Contact VARCHAR(100) NULL
);



CREATE TABLE Crew (
    Crew_ID INT PRIMARY KEY,
    Employee_ID INT,
    Role VARCHAR(50),
    Rank VARCHAR(50),
    Certification_Level VARCHAR(50),
    Nationality VARCHAR(50),
    License_Number VARCHAR(30),
    License_Expiry_Date DATE,
    Training_Hours INT,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);



CREATE TABLE Technician (
    Technician_ID INT PRIMARY KEY,
    Employee_ID INT,
    Specialty VARCHAR(100),
    Certification_Level VARCHAR(50),
    License_Number VARCHAR(30),
    License_Expiry_Date DATE,
    Training_Hours INT,
    Years_Experience INT,
    Supervisor_ID INT NULL,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
    FOREIGN KEY (Supervisor_ID) REFERENCES Technician(Technician_ID)
);



CREATE TABLE Maintenance_Type
(
    Maintenance_Type_ID INT PRIMARY KEY,
    Type_Name VARCHAR(100),
    Description NVARCHAR(1000),
    Tools_Required NVARCHAR(1000),
    Estimated_Duration_Hours INT,
    Frequency_Days INT,
    Is_Mandatory BIT DEFAULT 1,
    FAA_Required BIT
);



CREATE TABLE Flight
(
    Flight_ID INT PRIMARY KEY,
    Flight_Number VARCHAR(10),
    Aircraft_ID INT,
    Route_ID INT,
    Flight_Date DATE,
    Scheduled_Departure TIME,
    Scheduled_Arrival TIME,
    Actual_Departure TIME,
    Actual_Arrival TIME,
    Departure_Delay_Minutes INT,
    Arrival_Delay_Minutes INT,
    Passenger_Count INT,
    Revenue DECIMAL(10,2),
    Flight_Status VARCHAR(50),
    Cancelled BIT,
    Cancellation_Reason_Code VARCHAR(20),
    Cancellation_Date DATE,
    FOREIGN KEY (Aircraft_ID) REFERENCES Aircraft(Aircraft_ID),
    FOREIGN KEY (Route_ID) REFERENCES Route(Route_ID)
);



CREATE TABLE Ticket
(
    Ticket_ID INT PRIMARY KEY,
    Customer_ID INT,
    Flight_ID INT,
    Class_ID INT,
    Payment_Method_ID INT,
    Price DECIMAL(10,2),
    Discount DECIMAL(10,2),
    Final_Amount DECIMAL(10,2),
    Is_Refunded BIT,
    Sale_Date DATE,
    Created_At DATETIME2 DEFAULT SYSDATETIME(),
    Updated_At DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID),
    FOREIGN KEY (Class_ID) REFERENCES Class(Class_ID),
    FOREIGN KEY (Payment_Method_ID) REFERENCES Payment_Method(Payment_Method_ID)
);



CREATE TABLE Maintenance
(
    Maintenance_ID INT PRIMARY KEY,
    Aircraft_ID INT,
    Maintenance_Type_ID INT,
    Technician_ID INT,
    Maintenance_Start_Date DATE,
    Maintenance_End_Date DATE,
    Duration_Hours INT,
    Cost DECIMAL(10,2),
    Issue_Description NVARCHAR(2000),
    FOREIGN KEY (Aircraft_ID) REFERENCES Aircraft(Aircraft_ID),
    FOREIGN KEY (Maintenance_Type_ID) REFERENCES Maintenance_Type(Maintenance_Type_ID),
    FOREIGN KEY (Technician_ID) REFERENCES Technician(Technician_ID)
);



CREATE TABLE Feedback
(
    Customer_ID INT,
    Flight_ID INT,
    Feedback_Date DATE,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment_Text NVARCHAR(2000),
    PRIMARY KEY (Customer_ID, Flight_ID, Feedback_Date),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID)
);



CREATE TABLE Cargo
(
    Cargo_ID INT PRIMARY KEY,
    Customer_ID INT,
    Flight_ID INT,
    Cargo_Type_ID INT,
    Weight_KG DECIMAL(10,2),
    Volume_CM3 DECIMAL(10,2),
    Declared_Value DECIMAL(10,2),
    Is_Lost BIT,
    Is_Damaged BIT,
    Cargo_Date DATE,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID),
    FOREIGN KEY (Cargo_Type_ID) REFERENCES Cargo_Type(Cargo_Type_ID)
);



CREATE TABLE Flight_Crew
(
    Flight_ID INT,
    Crew_ID INT,
    Assignment_Date DATE,
    Role VARCHAR(50),
    PRIMARY KEY (Flight_ID, Crew_ID),
    FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID),
    FOREIGN KEY (Crew_ID) REFERENCES Crew(Crew_ID)
);

-- Add unique index for Flight_Number
CREATE UNIQUE INDEX idx_Flight_FlightNumber ON Flight(Flight_Number);
-- Add index for Route_ID
CREATE INDEX idx_Flight_RouteID ON Flight(Route_ID);
