-- this is the data command for the airline source database
GO
USE [master];
IF DB_ID('AirlineSourceDB') IS NULL
BEGIN
    RAISERROR('Database AirlineSourceDB does not exist.', 16, 1);
    RETURN;
END
GO
USE AirlineSourceDB;
GO



-- delete all data from source db (using DELETE because having References)
DELETE FROM Flight_Crew;
DELETE FROM Cargo;
DELETE FROM Cargo_Status;
DELETE FROM Feedback;
DELETE FROM Maintenance;
DELETE FROM Booking;
DELETE FROM Ticket;
DELETE FROM Ticket_Status;
DELETE FROM Booking_Cancellation_Reason;
DELETE FROM Flight;
DELETE FROM Flight_Status;
DELETE FROM Maintenance_Type;
DELETE FROM Technician;
DELETE FROM Crew;
DELETE FROM Crew_Role;
DELETE FROM Crew_Role_Type;
DELETE FROM Employee;
DELETE FROM Cargo_Type;
DELETE FROM Payment_Method;
DELETE FROM Class;
DELETE FROM Customer;
DELETE FROM Loyalty_Tier;
DELETE FROM Route;
DELETE FROM Airport;
DELETE FROM Aircraft;
GO



-- Table Aircraft
INSERT INTO Aircraft
    (Aircraft_ID, Registration_Number, Model, Manufacturer, Manufacture_Date, Engine_Type, Max_Range_KM, Passenger_Capacity, Fuel_Capacity_Liters, Cargo_Capacity_KG, Is_Active)
VALUES
    (1, 'EP-AIA', 'A320-200', 'Airbus', '2015-05-20', 'CFM56-5B4', 6150, 180, 24210.00, 3000, 1),
    (2, 'EP-AIB', '737-800', 'Boeing', '2012-11-10', 'CFM56-7B', 5449, 189, 26020.00, 4300, 1),
    (3, 'EP-AIC', 'A330-300', 'Airbus', '2018-02-15', 'Rolls-Royce Trent 700', 11750, 277, 97530.00, 19000, 1),
    (4, 'EP-AID', '777-300ER', 'Boeing', '2019-08-01', 'GE90-115B', 13649, 396, 181280.00, 22000, 1),
    (5, 'EP-AIE', 'ATR 72-600', 'ATR', '2017-06-30', 'PW127M', 1528, 72, 5000.00, 1500, 1),
    (6, 'EP-AIF', 'A350-900', 'Airbus', '2021-03-22', 'Rolls-Royce Trent XWB', 15000, 325, 141000.00, 20000, 1),
    (7, 'EP-AIG', '787-9 Dreamliner', 'Boeing', '2020-09-11', 'GEnx-1B', 14140, 290, 126372.00, 18000, 1),
    (8, 'EP-AIH', 'A321neo', 'Airbus', '2022-01-05', 'CFM LEAP-1A', 7400, 240, 32940.00, 5000, 1),
    (9, 'EP-AII', 'Embraer E195-E2', 'Embraer', '2021-07-14', 'Pratt & Whitney PW1900G', 4815, 146, 13600.00, 2500, 1),
    (10, 'EP-AIJ', '747-400', 'Boeing', '2005-10-18', 'CF6-80C2B1F', 13450, 416, 216840.00, 25000, 0);
GO



-- Table Airport
INSERT INTO Airport
    (Airport_Code, Airport_Name, IATA_Code, ICAO_Code, City, Country, Latitude, Longitude, Timezone, Elevation_Feet, Terminal_Count, Opening_Date, Is_International, Is_Active)
VALUES
    ('IKA01', 'Imam Khomeini International Airport', 'IKA', 'OIIE', 'Tehran', 'Iran', 35.416100, 51.152200, 'UTC+3:30', 3305, 2, '2004-05-05', 1, 1),
    ('MHD01', 'Mashhad International Airport', 'MHD', 'OIMM', 'Mashhad', 'Iran', 36.237300, 59.643300, 'UTC+3:30', 3258, 3, '1951-01-01', 1, 1),
    ('SYZ01', 'Shiraz International Airport', 'SYZ', 'OISS', 'Shiraz', 'Iran', 29.539200, 52.589800, 'UTC+3:30', 4927, 2, '1960-01-01', 1, 1),
    ('IST01', 'Istanbul Airport', 'IST', 'LTFM', 'Istanbul', 'Turkey', 41.275300, 28.751900, 'UTC+3:00', 325, 1, '2018-10-29', 1, 1),
    ('DXB01', 'Dubai International Airport', 'DXB', 'OMDB', 'Dubai', 'UAE', 25.253175, 55.365673, 'UTC+4:00', 62, 3, '1960-09-30', 1, 1),
    ('LHR01', 'Heathrow Airport', 'LHR', 'EGLL', 'London', 'UK', 51.470000, -0.454300, 'UTC+1:00', 83, 5, '1946-05-31', 1, 1),
    ('JFK01', 'John F. Kennedy International Airport', 'JFK', 'KJFK', 'New York', 'USA', 40.641300, -73.778100, 'UTC-4:00', 42, 6, '1948-07-01', 1, 1),
    ('HND01', 'Tokyo Haneda Airport', 'HND', 'RJTT', 'Tokyo', 'Japan', 35.549400, 139.779800, 'UTC+9:00', 35, 3, '1931-08-25', 1, 1),
    ('IFN01', 'Isfahan International Airport', 'IFN', 'OIFM', 'Isfahan', 'Iran', 32.748600, 51.860100, 'UTC+3:30', 5069, 2, '1982-01-01', 1, 1),
    ('AMS01', 'Amsterdam Airport Schiphol', 'AMS', 'EHAM', 'Amsterdam', 'Netherlands', 52.310500, 4.768300, 'UTC+2:00', -11, 1, '1916-09-16', 1, 1);
GO



-- Table Route
INSERT INTO Route
    (Route_ID, Route_Code, Route_Name, Origin_Airport_Code, Destination_Airport_Code, Distance_KM, Flight_Duration_Minutes, Is_International, Is_Active)
VALUES
    (1, 'IKA-MHD', 'Tehran to Mashhad', 'IKA01', 'MHD01', 745, 90, 0, 1),
    (2, 'IKA-SYZ', 'Tehran to Shiraz', 'IKA01', 'SYZ01', 690, 85, 0, 1),
    (3, 'IKA-IST', 'Tehran to Istanbul', 'IKA01', 'IST01', 2045, 180, 1, 1),
    (4, 'IKA-DXB', 'Tehran to Dubai', 'IKA01', 'DXB01', 1199, 140, 1, 1),
    (5, 'MHD-DXB', 'Mashhad to Dubai', 'MHD01', 'DXB01', 1330, 150, 1, 1),
    (6, 'SYZ-IST', 'Shiraz to Istanbul', 'SYZ01', 'IST01', 2500, 210, 1, 1),
    (7, 'DXB-LHR', 'Dubai to London', 'DXB01', 'LHR01', 5475, 450, 1, 1),
    (8, 'JFK-LHR', 'New York to London', 'JFK01', 'LHR01', 5570, 420, 1, 1),
    (9, 'HND-JFK', 'Tokyo to New York', 'HND01', 'JFK01', 10850, 780, 1, 1),
    (10, 'IKA-AMS', 'Tehran to Amsterdam', 'IKA01', 'AMS01', 4095, 330, 1, 1);
GO



-- Table Loyalty_Tier
INSERT INTO Loyalty_Tier
    (Loyalty_Tier_ID, Tier_Name, Benefits, Required_Points, Is_Active)
VALUES
    (1, 'Bronze', 'Standard benefits, 5% discount on baggage fees.', 0, 1),
    (2, 'Silver', 'Priority check-in, extra 10kg baggage allowance.', 5000, 1),
    (3, 'Gold', 'Lounge access, priority boarding, two free checked bags.', 15000, 1),
    (4, 'Platinum', 'First class lounge access, dedicated support line, free seat upgrades.', 40000, 1),
    (5, 'Diamond', 'All Platinum benefits, guaranteed seat on any flight, personal travel assistant.', 100000, 1),
    (6, 'Standard', 'Basic access to booking.', 0, 1),
    (7, 'Plus', 'Advanced booking options.', 2000, 1),
    (8, 'Premium', 'Exclusive deals and offers.', 8000, 1),
    (9, 'Executive', 'Corporate travel benefits.', 25000, 1),
    (10, 'VIP', 'Highest level of personal service.', 75000, 1);
GO



-- Table Customer
INSERT INTO Customer
    (Customer_ID, Passport_Code, First_Name, Last_Name, Email, Phone_Number, Gender, Birth_Date, Nationality, City, Country, Address, Postal_Code, Preferred_Language, Loyalty_Tier_ID, Loyalty_Points, Loyalty_Change_Date, Is_Active, Last_Login_Date)
VALUES
    (1, 'A12345678', 'Babak', 'Rostami', 'babak.r@email.com', '989121234567', 'M', '1980-01-15', 'Iranian', 'Tehran', 'Iran', '123 Azadi St', '14579', 'Persian', 3, 18000, '2023-05-10', 1, '2024-06-20 10:00:00'),
    (2, 'B87654321', 'Shirin', 'Alavi', 'shirin.a@email.com', '989122345678', 'F', '1992-07-22', 'Iranian', 'Shiraz', 'Iran', '456 Zand Ave', '71358', 'Persian', 2, 6500, '2023-02-15', 1, '2024-06-18 15:30:00'),
    (3, 'C24681357', 'John', 'Smith', 'john.smith@email.com', '14155552671', 'M', '1975-11-30', 'American', 'New York', 'USA', '789 Broadway', '10003', 'English', 4, 52000, '2022-12-01', 1, '2024-06-22 08:45:00'),
    (4, 'D13579246', 'Ayse', 'Yilmaz', 'ayse.y@email.com', '905321234567', 'F', '1988-04-05', 'Turkish', 'Istanbul', 'Turkey', '159 Istiklal Cd', '34430', 'Turkish', 2, 8900, '2023-01-20', 1, '2024-06-15 11:00:00'),
    (5, 'E98765432', 'Fatima', 'Al Mansoori', 'fatima.m@email.com', '971501234567', 'F', '1995-09-12', 'Emirati', 'Dubai', 'UAE', '321 Sheikh Zayed Rd', '337-1500', 'Arabic', 3, 25000, '2023-08-05', 1, '2024-06-21 14:20:00'),
    (6, 'F11223344', 'Kian', 'Parsi', 'kian.p@email.com', '989171112233', 'M', '2000-12-01', 'Iranian', 'Isfahan', 'Iran', '77 Chaharbagh St', '81464', 'Persian', 1, 1200, '2024-01-10', 1, '2024-05-30 19:00:00'),
    (7, 'G55667788', 'Yuki', 'Tanaka', 'yuki.t@email.com', '819012345678', 'F', '1998-06-25', 'Japanese', 'Tokyo', 'Japan', '45 Ginza', '104-0061', 'Japanese', 1, 450, '2023-11-11', 1, '2024-06-10 22:10:00'),
    (8, 'H99887766', 'Hans', 'Müller', 'hans.m@email.com', '4917612345678', 'M', '1965-02-18', 'German', 'Berlin', 'Germany', 'Kurfürstendamm 22', '10719', 'German', 5, 120000, '2021-07-30', 1, '2024-06-23 09:00:00'),
    (9, 'I12121212', 'Mina', 'Kazemi', 'mina.k@email.com', '989151212121', 'F', '1983-08-08', 'Iranian', 'Mashhad', 'Iran', 'Sajjad Blvd', '91888', 'Persian', 2, 7200, '2023-09-09', 1, '2024-06-19 18:00:00'),
    (10, 'J34343434', 'David', 'Chen', 'david.c@email.com', '8613912345678', 'M', '1991-03-14', 'Chinese', 'Beijing', 'China', '1 Wangfujing St', '100006', 'Mandarin', 3, 31000, '2022-10-15', 1, '2024-06-22 13:05:00');
GO



-- Table Class
INSERT INTO Class
    (Class_ID, Class_Code, Class_Name, Description, Base_Price_Multiplier, Change_Fee_Amount, Cancellation_Fee_Amount, Baggage_Allowance_KG, Carry_On_Allowance_KG, Is_Active)
VALUES
    (1, 'ECO', 'Economy', 'Standard seating with basic services.', 1.00, 100.00, 200.00, 20.00, 7.00, 1),
    (2, 'PRE', 'Premium Economy', 'More legroom and enhanced meal service.', 1.50, 50.00, 150.00, 25.00, 10.00, 1),
    (3, 'BUS', 'Business', 'Lie-flat seats, fine dining, and lounge access.', 3.00, 25.00, 100.00, 35.00, 12.00, 1),
    (4, 'FIR', 'First Class', 'Private suite, gourmet meals, and exclusive services.', 5.00, 0.00, 50.00, 45.00, 15.00, 1),
    (5, 'SAV', 'Saver', 'Most restrictive fare, no changes allowed.', 0.80, 150.00, 300.00, 15.00, 5.00, 1),
    (6, 'FLX', 'Flexible Economy', 'Economy seat with free changes.', 1.20, 0.00, 50.00, 20.00, 8.00, 1),
    (7, 'CORP', 'Corporate', 'Business class perks for corporate clients.', 2.80, 10.00, 80.00, 40.00, 12.00, 1),
    (8, 'GRP', 'Group', 'Discounted fare for group bookings.', 0.90, 120.00, 250.00, 20.00, 7.00, 1),
    (9, 'STU', 'Student', 'Special fare for students with valid ID.', 0.85, 80.00, 180.00, 25.00, 7.00, 1),
    (10, 'MIL', 'Military', 'Discounted fare for military personnel.', 0.85, 40.00, 120.00, 30.00, 10.00, 1);
GO



-- Table Payment_Method
INSERT INTO Payment_Method
    (Payment_Method_ID, Method_Name, Description, Provider_Name, Processing_Fee, Currency, Is_Active)
VALUES
    (1, 'Credit Card', 'Visa, Mastercard, AMEX', 'Stripe', 2.90, 'USD', 1),
    (2, 'Debit Card', 'Local and international debit cards', 'Adyen', 1.50, 'USD', 1),
    (3, 'PayPal', 'Online payment system', 'PayPal Inc.', 3.50, 'USD', 1),
    (4, 'Bank Transfer', 'Direct bank transfer', 'Local Banks', 0.50, 'IRR', 1),
    (5, 'Apple Pay', 'Mobile payment', 'Apple Inc.', 2.50, 'USD', 1),
    (6, 'Google Pay', 'Mobile payment', 'Google LLC', 2.50, 'USD', 1),
    (7, 'Airline Miles', 'Payment with loyalty points', 'Airline Loyalty Program', 0.00, NULL, 1),
    (8, 'Gift Card', 'Prepaid gift card', 'Airline Inc.', 0.00, 'USD', 1),
    (9, 'Shetab', 'Iranian local payment gateway', 'SHAPARAK', 1.00, 'IRR', 1),
    (10, 'AliPay', 'Chinese mobile payment', 'Ant Group', 2.00, 'CNY', 1);
GO



-- Table Cargo_Type
INSERT INTO Cargo_Type
    (Cargo_Type_ID, Type_Name, Description, Is_Hazardous, Max_Weight_KG)
VALUES
    (1, 'General Cargo', 'Standard goods and materials.', 0, 5000.00),
    (2, 'Perishable Goods', 'Items requiring temperature control, like food.', 0, 2000.00),
    (3, 'Live Animals', 'Transport of living animals according to IATA regulations.', 0, 1000.00),
    (4, 'Hazardous Materials - Class 1', 'Explosives.', 1, 500.00),
    (5, 'Valuable Cargo', 'High-value items like jewelry and currency.', 0, 100.00),
    (6, 'Human Remains', 'Coffins or cremated remains.', 0, 250.00),
    (7, 'Medical Supplies', 'Urgent medical equipment and pharmaceuticals.', 0, 1500.00),
    (8, 'Automotive Parts', 'Car parts and machinery.', 0, 10000.00),
    (9, 'Mail', 'Postal service mail and packages.', 0, 3000.00),
    (10, 'Dangerous Goods - Misc', 'Miscellaneous dangerous goods not covered in other classes.', 1, 750.00);
GO



-- Table Employee
INSERT INTO Employee
    (Employee_ID, First_Name, Last_Name, Email, Phone_Number, Birth_Date, Hire_Date, Exit_Date, Emergency_Contact)
VALUES
    (1, 'Ali', 'Rezai', 'ali.rezai@airline.com', '989121111111', '1985-03-12', '2010-05-15', NULL, 'Sara Rezai - 989121111112'),
    (2, 'Fatemeh', 'Ahmadi', 'fatemeh.ahmadi@airline.com', '989122222222', '1990-08-25', '2015-02-20', NULL, 'Reza Ahmadi - 989122222223'),
    (3, 'Hassan', 'Karimi', 'hassan.karimi@airline.com', '989123333333', '1988-11-30', '2012-09-01', NULL, 'Maryam Karimi - 989123333334'),
    (4, 'Zahra', 'Sadeghi', 'zahra.sadeghi@airline.com', '989124444444', '1992-01-15', '2018-07-10', NULL, 'Naser Sadeghi - 989124444445'),
    (5, 'Mohammad', 'Hosseini', 'mohammad.hosseini@airline.com', '989125555555', '1979-06-20', '2005-01-12', '2023-12-31', 'Layla Hosseini - 989125555556'),
    (6, 'Narges', 'Abbasi', 'narges.abbasi@airline.com', '989126666666', '1995-04-18', '2020-03-01', NULL, 'Javad Abbasi - 989126666667'),
    (7, 'Reza', 'Moradi', 'reza.moradi@airline.com', '989127777777', '1982-12-05', '2008-11-20', NULL, 'Shirin Moradi - 989127777778'),
    (8, 'Maryam', 'Jafari', 'maryam.jafari@airline.com', '989128888888', '1993-09-08', '2019-05-15', NULL, 'Kian Jafari - 989128888889'),
    (9, 'Saeid', 'Hashemi', 'saeid.hashemi@airline.com', '989129999999', '1991-07-22', '2016-10-05', NULL, 'Fariba Hashemi - 989129999990'),
    (10, 'Sara', 'Ebrahimi', 'sara.ebrahimi@airline.com', '989120000000', '1986-10-10', '2011-04-30', NULL, 'Kamran Ebrahimi - 989120000001'),
    (11, 'Amir', 'Bagheri', 'amir.bagheri@tech.com', '989131111111', '1980-02-20', '2009-06-10', NULL, 'Mina Bagheri - 989131111112'),
    (12, 'Parisa', 'Davari', 'parisa.davari@tech.com', '989132222222', '1987-05-14', '2013-08-19', NULL, 'Farhad Davari - 989132222223'),
    (13, 'Kian', 'Ranjbar', 'kian.ranjbar@tech.com', '989133333333', '1990-01-25', '2017-11-01', NULL, 'Negar Ranjbar - 989133333334'),
    (14, 'Shadi', 'Asgari', 'shadi.asgari@tech.com', '989134444444', '1994-03-17', '2021-02-28', NULL, 'Babak Asgari - 989134444445'),
    (15, 'Farhad', 'Zamani', 'farhad.zamani@tech.com', '989135555555', '1983-09-09', '2011-12-12', NULL, 'Shiva Zamani - 989135555556');
GO



-- Table Crew_Role_Type
INSERT INTO Crew_Role_Type
    (Role_Type_ID, Role_Type_Name, Description)
VALUES
    (1, 'Pilot', 'Responsible for flying the aircraft.'),
    (2, 'Cabin Crew', 'Responsible for passenger safety and service.'),
    (3, 'Ground Staff', 'Handles operations at the airport.'),
    (4, 'Air Marshal', 'Undercover security on board.'),
    (5, 'Flight Engineer', 'Monitors aircraft systems.');
GO



-- Table Crew_Role
INSERT INTO Crew_Role
    (Crew_Role_ID, Crew_Role_Type_ID, Role_Name, Description, Basic_Fee_Per_Hour)
VALUES
    (1, 1, 'Captain', 'Commands the aircraft and is responsible for the safety of all on board.', 150.00),
    (2, 1, 'First Officer', 'Second in command, assists the Captain.', 100.00),
    (3, 2, 'Purser', 'Head of the cabin crew, ensures quality of service and safety procedures.', 50.00),
    (4, 2, 'Flight Attendant', 'Provides routine services and responds to emergencies.', 35.00),
    (5, 5, 'Flight Engineer', 'Monitors aircraft systems, typically on older aircraft.', 80.00),
    (6, 1, 'Relief Pilot', 'Takes over piloting duties on long-haul flights.', 95.00),
    (7, 2, 'Senior Flight Attendant', 'An experienced flight attendant with supervisory duties.', 45.00),
    (8, 3, 'Gate Agent', 'Assists passengers with check-in and boarding at the gate.', 25.00),
    (9, 3, 'Baggage Handler', 'Loads and unloads baggage and cargo.', 20.00),
    (10, 4, 'Federal Air Marshal', 'Provides anonymous security on flights.', 120.00);
GO



-- Table Crew
INSERT INTO Crew
    (Crew_ID, Employee_ID, Crew_Role_Type_ID, Certification_Level, Nationality, License_Number, License_Expiry_Date, Training_Hours)
VALUES
    (1, 1, 1, 'ATPL', 'Iranian', 'IR-PL-1111', '2028-12-31', 15000),
    (2, 2, 2, 'Senior', 'Iranian', 'IR-CA-2222', '2027-10-15', 5000),
    (3, 3, 1, 'ATPL', 'Iranian', 'IR-PL-3333', '2029-05-20', 12000),
    (4, 4, 2, 'Junior', 'Iranian', 'IR-CA-4444', '2026-08-30', 2500),
    (5, 6, 2, 'Senior', 'Iranian', 'IR-CA-6666', '2028-02-10', 6000),
    (6, 7, 1, 'CPL', 'Iranian', 'IR-PL-7777', '2027-11-25', 8000),
    (7, 8, 2, 'Purser', 'Iranian', 'IR-CA-8888', '2029-01-01', 9000),
    (8, 9, 1, 'ATPL', 'Iranian', 'IR-PL-9999', '2030-03-14', 18000),
    (9, 10, 2, 'Junior', 'Iranian', 'IR-CA-0000', '2025-12-12', 1500),
    (10, 5, 5, 'FE-Jet', 'Iranian', 'IR-FE-5555', '2025-06-30', 7500);
GO



-- Table Technician
INSERT INTO Technician
    (Technician_ID, Employee_ID, Specialty, Certification_Level, License_Number, License_Expiry_Date, Training_Hours, Years_Experience, Supervisor_ID)
VALUES
    (1, 11, 'Avionics', 'FAA A&P, IA', 'US-TECH-111', '2027-08-15', 3000, 15, NULL),
    (2, 12, 'Airframe', 'EASA Part-66 B1', 'EU-TECH-222', '2028-04-10', 2500, 11, 1),
    (3, 13, 'Powerplant', 'EASA Part-66 B1', 'EU-TECH-333', '2026-11-20', 1800, 7, 1),
    (4, 14, 'Composites', 'Specialist Cert', 'CMP-TECH-444', '2029-01-30', 1200, 3, 2),
    (5, 15, 'NDT', 'Level III', 'NDT-TECH-555', '2027-09-05', 4000, 13, 1);
GO



-- Table Maintenance_Type
INSERT INTO Maintenance_Type
    (Maintenance_Type_ID, Type_Name, Issue_Description, Resolution_Notes, Parts_Replace, Tools_Required, Estimated_Cost, Estimated_Duration_Hours, FAA_Required)
VALUES
    (1, 'A-Check', 'Routine check performed every 400-600 flight hours.', 'Visual inspection, lubrication, filter changes.', 'Oil Filter, Hydraulic Fluid', 'Standard toolkit, inspection light', 5000.00, 10, 1),
    (2, 'B-Check', 'More detailed check every 6-8 months.', 'Detailed systems checks, component testing.', 'Various seals and gaskets', 'Specialized diagnostic tools', 20000.00, 24, 1),
    (3, 'C-Check', 'Heavy maintenance check every 20-24 months.', 'Extensive disassembly, inspection, and repair of aircraft structures and systems.', 'Landing gear components, engine parts', 'Hangar facilities, heavy machinery', 200000.00, 168, 1),
    (4, 'D-Check', 'Most comprehensive check, almost a complete overhaul.', 'Aircraft completely taken apart for inspection and repair.', 'Major structural components', 'Full MRO facility', 1000000.00, 720, 1),
    (5, 'Engine Replacement', 'Full replacement of a jet engine.', 'Old engine removed, new engine installed and tested.', 'Complete engine unit', 'Engine hoist, specific adapters', 2500000.00, 48, 1),
    (6, 'Tire Replacement', 'Replacement of worn landing gear tires.', 'Worn tires removed, new tires installed.', 'Aircraft tires', 'Jack, lug wrench', 1500.00, 2, 0),
    (7, 'Avionics Update', 'Software or hardware update for flight systems.', 'New navigation or communication system installed.', 'Avionics modules', 'Soldering iron, diagnostic laptop', 15000.00, 8, 1),
    (8, 'Cabin Refurbishment', 'Interior update.', 'Seats, carpets, and lighting replaced.', 'Seat covers, LED lights', 'Upholstery tools', 50000.00, 72, 0),
    (9, 'Paint Job', 'Repainting the aircraft livery.', 'Old paint stripped, new paint applied.', 'Aircraft paint, sealant', 'Paint sprayers, sanding equipment', 80000.00, 120, 0),
    (10, 'Window Replacement', 'Replacement of a cracked cockpit or cabin window.', 'Damaged window removed, new one sealed in place.', 'Acrylic window pane, sealant', 'Suction cups, sealant gun', 8000.00, 4, 1);
GO



-- Table Flight_Status
INSERT INTO Flight_Status
    (Flight_Status_ID, Status_Name, Description)
VALUES
    (1, 'Scheduled', 'Flight is scheduled to depart on time.'),
    (2, 'On Time', 'Flight is currently on time.'),
    (3, 'Delayed', 'Flight is delayed.'),
    (4, 'Departed', 'Flight has departed from the origin airport.'),
    (5, 'In Air', 'Flight is currently in the air.'),
    (6, 'Arrived', 'Flight has arrived at the destination airport.'),
    (7, 'Cancelled', 'Flight has been cancelled.'),
    (8, 'Diverted', 'Flight has been diverted to another airport.'),
    (9, 'Boarding', 'Passengers are currently boarding the aircraft.'),
    (10, 'Gate Change', 'The departure gate for the flight has changed.');
GO



-- Table Flight
INSERT INTO Flight
    (Flight_ID, Flight_Number, Flight_Date, Aircraft_ID, Route_ID, Scheduled_Departure, Scheduled_Arrival, Actual_Departure, Actual_Arrival, Passenger_Count, Revenue, Fuel_Cost, Service_Cost, Flight_Status_ID)
VALUES
    (1, 'IR350', '2024-06-25', 1, 1, '2024-06-25 08:00:00', '2024-06-25 09:30:00', '2024-06-25 08:05:00', '2024-06-25 09:28:00', 175, 43750.00, 8000.00, 3000.00, 6),
    (2, 'IR351', '2024-06-25', 2, 2, '2024-06-25 10:00:00', '2024-06-25 11:25:00', '2024-06-25 10:00:00', '2024-06-25 11:20:00', 180, 54000.00, 9500.00, 3500.00, 6),
    (3, 'TK879', '2024-06-26', 3, 3, '2024-06-26 14:00:00', '2024-06-26 17:00:00', '2024-06-26 14:15:00', '2024-06-26 17:10:00', 250, 250000.00, 45000.00, 15000.00, 5),
    (4, 'EK901', '2024-06-26', 4, 4, '2024-06-26 18:00:00', '2024-06-26 20:20:00', NULL, NULL, 200, 180000.00, 30000.00, 12000.00, 1),
    (5, 'IR360', '2024-06-27', 5, 5, '2024-06-27 09:00:00', '2024-06-27 11:30:00', NULL, NULL, 65, 26000.00, 6000.00, 2000.00, 1),
    (6, 'TK885', '2024-06-27', 6, 6, '2024-06-27 11:00:00', '2024-06-27 14:30:00', NULL, NULL, 300, 330000.00, 60000.00, 20000.00, 1),
    (7, 'BA106', '2024-06-28', 7, 7, '2024-06-28 02:00:00', '2024-06-28 09:30:00', NULL, NULL, 280, 420000.00, 95000.00, 30000.00, 1),
    (8, 'VS4', '2024-06-28', 8, 8, '2024-06-28 19:30:00', '2024-06-29 02:30:00', NULL, NULL, 230, 345000.00, 80000.00, 25000.00, 1),
    (9, 'JL5', '2024-06-29', 9, 9, '2024-06-29 11:00:00', '2024-06-30 00:00:00', NULL, NULL, 140, 490000.00, 150000.00, 40000.00, 1),
    (10, 'KL434', '2024-06-29', 1, 10, '2024-06-29 05:00:00', '2024-06-29 10:30:00', NULL, NULL, 150, 120000.00, 65000.00, 18000.00, 7);
GO



-- Table Booking_Cancellation_Reason
INSERT INTO Booking_Cancellation_Reason
    (Cancellation_ID, Reason, Description)
VALUES
    (1, 'Change of Plans', 'Customer voluntarily changed their travel plans.'),
    (2, 'Medical Emergency', 'Cancellation due to a medical issue for the passenger or family.'),
    (3, 'Flight Cancelled by Airline', 'The airline cancelled the flight.'),
    (4, 'Missed Connection', 'Passenger missed a connecting flight.'),
    (5, 'Weather Conditions', 'Flight cancelled or delayed due to bad weather.'),
    (6, 'Business Reasons', 'Work-related cancellation.'),
    (7, 'Duplicate Booking', 'Customer made a duplicate booking by mistake.'),
    (8, 'No Show', 'Passenger did not show up for the flight.'),
    (9, 'Visa/Documentation Issues', 'Passenger had problems with travel documents.'),
    (10, 'Bereavement', 'Cancellation due to a death in the family.');
GO



-- Table Ticket_Status
INSERT INTO Ticket_Status
    (Status_ID, Name, Description)
VALUES
    (1, 'Confirmed', 'The ticket is confirmed and the seat is reserved.'),
    (2, 'Cancelled', 'The ticket has been cancelled.'),
    (3, 'Used', 'The ticket has been used for travel.'),
    (4, 'Pending', 'The ticket booking is pending payment or confirmation.'),
    (5, 'Refunded', 'The ticket has been cancelled and refunded.'),
    (6, 'Exchanged', 'The ticket was exchanged for another flight.'),
    (7, 'Open', 'An open ticket with a flexible travel date.'),
    (8, 'Waitlisted', 'The passenger is on the waitlist for the flight.'),
    (9, 'Checked-In', 'The passenger has checked in for the flight.'),
    (10, 'No-Show', 'The passenger did not show up for the flight.');
GO



-- Table Ticket
INSERT INTO Ticket
    (Ticket_ID, Flight_ID, Class_ID, Ticket_Status_ID, Price, Discount, Seat_Number)
VALUES
    (1, 1, 1, 3, 250.00, 0.00, '12A'),
    (2, 1, 1, 3, 250.00, 10.00, '12B'),
    (3, 2, 2, 3, 450.00, 0.00, '8C'),
    (4, 3, 3, 1, 1000.00, 100.00, '2A'),
    (5, 4, 4, 1, 2000.00, 0.00, '1F'),
    (6, 5, 1, 1, 400.00, 20.00, '15D'),
    (7, 6, 2, 1, 1100.00, 0.00, '10A'),
    (8, 7, 3, 1, 1500.00, 50.00, '3G'),
    (9, 8, 1, 2, 1500.00, 0.00, '30F'),
    (10, 10, 1, 1, 800.00, 0.00, '25C'),
    (11, 3, 3, 1, 1000.00, 0, '2B'),
    (12, 1, 1, 5, 250.00, 0, '14E');
GO



-- Table Booking
INSERT INTO Booking
    (Booking_ID, Ticket_ID, Customer_ID, Payment_Method_ID, Booking_Date, Total_Amount, Cancellation_Reason_ID, Cancellation_Fee)
VALUES
    (1, 1, 1, 1, '2024-05-10 10:00:00', 250.00, NULL, NULL),
    (2, 2, 2, 9, '2024-05-11 11:30:00', 240.00, NULL, NULL),
    (3, 3, 9, 2, '2024-05-15 14:00:00', 450.00, NULL, NULL),
    (4, 4, 4, 1, '2024-05-20 09:00:00', 900.00, NULL, NULL),
    (5, 5, 5, 5, '2024-05-22 18:20:00', 2000.00, NULL, NULL),
    (6, 6, 6, 9, '2024-06-01 12:00:00', 380.00, NULL, NULL),
    (7, 7, 3, 3, '2024-06-05 21:00:00', 1100.00, NULL, NULL),
    (8, 8, 8, 6, '2024-06-10 08:45:00', 1450.00, NULL, NULL),
    (9, 9, 7, 1, '2024-06-12 13:00:00', 1500.00, 1, 100.00),
    (10, 10, 10, 1, '2024-06-15 16:50:00', 800.00, 3, 0.00),
    (11, 11, 4, 1, '2024-05-20 09:01:00', 1000.00, NULL, NULL),
    (12, 12, 1, 1, '2024-05-01 10:00:00', 250.00, 1, 200.00);
GO



-- Table Maintenance
INSERT INTO Maintenance
    (Maintenance_ID, Aircraft_ID, Airport_Code, Maintenance_Type_ID, Supervise_Technician_ID, Maintenance_Start_Date, Maintenance_End_Date, Part_Cost, Technician_Fee, Technician_Count)
VALUES
    (1, 1, 'IKA01', 1, 1, '2024-06-01 08:00:00', '2024-06-01 18:00:00', 200.00, 1500.00, 3),
    (2, 2, 'MHD01', 6, 2, '2024-06-05 10:00:00', '2024-06-05 12:00:00', 1200.00, 400.00, 2),
    (3, 3, 'DXB01', 7, 1, '2024-05-20 09:00:00', '2024-05-20 19:00:00', 10000.00, 2000.00, 2),
    (4, 4, 'IKA01', 2, 1, '2024-05-10 08:00:00', '2024-05-11 10:00:00', 15000.00, 5000.00, 5),
    (5, 10, 'IKA01', 5, 1, '2024-01-10 08:00:00', '2024-01-12 18:00:00', 1800000.00, 10000.00, 8),
    (6, 6, 'AMS01', 3, 1, '2023-11-01 00:00:00', '2023-11-08 00:00:00', 150000.00, 40000.00, 10),
    (7, 7, 'JFK01', 1, 1, '2024-06-15 08:00:00', '2024-06-15 19:00:00', 300.00, 1600.00, 4),
    (8, 8, 'IST01', 10, 2, '2024-04-25 14:00:00', '2024-04-25 18:30:00', 5000.00, 1000.00, 2),
    (9, 5, 'SYZ01', 6, 3, '2024-06-20 10:00:00', '2024-06-20 11:30:00', 1100.00, 300.00, 2),
    (10, 9, 'IKA01', 8, 2, '2024-02-15 08:00:00', '2024-02-18 08:00:00', 30000.00, 8000.00, 6);
GO



-- Table Feedback
INSERT INTO Feedback
    (Feedback_ID, Ticket_ID, Flight_ID, Feedback_Date, Rating, Comment_Text, Analyzed_Text_Feedback)
VALUES
    (1, 1, 1, '2024-06-25', 5, 'Great flight, very smooth and on time. Crew was very friendly.', 5),
    (2, 2, 1, '2024-06-25', 4, 'Good flight overall, but the boarding process was a bit chaotic.', 3),
    (3, 3, 2, '2024-06-25', 5, 'Excellent service in premium economy. Worth the upgrade!', 5),
    (4, 4, 3, '2024-06-26', 3, 'The flight was delayed by 15 minutes, but the cabin crew was apologetic. Food was average.', -1),
    (5, 11, 3, '2024-06-26', 4, 'Very comfortable seat in business class. Attentive service.', 4);
GO



-- Table Cargo_Status
INSERT INTO Cargo_Status
    (Cargo_Status_ID, Status_Name, Description)
VALUES
    (1, 'Booked', 'Cargo space has been booked.'),
    (2, 'Received at Warehouse', 'Cargo has been received at the origin warehouse.'),
    (3, 'Loaded onto Aircraft', 'Cargo has been loaded onto the aircraft.'),
    (4, 'In Transit', 'Cargo is currently in transit.'),
    (5, 'Arrived at Destination', 'Cargo has arrived at the destination airport.'),
    (6, 'Cleared Customs', 'Cargo has cleared customs at the destination.'),
    (7, 'Out for Delivery', 'Cargo is out for final delivery.'),
    (8, 'Delivered', 'Cargo has been successfully delivered.'),
    (9, 'On Hold', 'Cargo is on hold due to documentation or other issues.'),
    (10, 'Cancelled', 'The cargo shipment has been cancelled.');
GO



-- Table Cargo
INSERT INTO Cargo
    (Cargo_ID, Cargo_Status_ID, Ticket_ID, Flight_ID, Cargo_Type_ID, Weight_KG, Volume_CM3, Declared_Value, Cargo_Delivery_Date)
VALUES
    (1, 8, 1, 1, 1, 50.00, 10000.00, 500.00, '2024-06-26'),
    (2, 5, 3, 2, 2, 100.00, 50000.00, 2000.00, '2024-06-27'),
    (3, 3, 4, 3, 5, 5.00, 1000.00, 10000.00, '2024-06-28'),
    (4, 2, 5, 4, 7, 250.00, 80000.00, 5000.00, '2024-06-29'),
    (5, 1, 6, 5, 9, 500.00, 200000.00, 1000.00, '2024-06-30');
GO



-- Table Flight_Crew
INSERT INTO Flight_Crew
    (Flight_ID, Crew_ID, Crew_Role_ID, Assignment_Date, Duration_Hours, Hourly_Fee, Bonus, Start_Time, End_Time, Rating)
VALUES
    (1, 1, 1, '2024-06-25', 4.00, 150.00, 200.00, '2024-06-25 07:00:00', '2024-06-25 11:00:00', 5),
    (1, 6, 2, '2024-06-25', 4.00, 100.00, 100.00, '2024-06-25 07:00:00', '2024-06-25 11:00:00', 4),
    (1, 2, 3, '2024-06-25', 5.00, 50.00, 50.00, '2024-06-25 07:00:00', '2024-06-25 12:00:00', 5),
    (1, 4, 4, '2024-06-25', 5.00, 35.00, 0.00, '2024-06-25 07:00:00', '2024-06-25 12:00:00', 4),
    (2, 3, 1, '2024-06-25', 4.00, 150.00, 200.00, '2024-06-25 09:00:00', '2024-06-25 13:00:00', 5),
    (2, 8, 2, '2024-06-25', 4.00, 100.00, 100.00, '2024-06-25 09:00:00', '2024-06-25 13:00:00', 5),
    (2, 5, 3, '2024-06-25', 5.00, 50.00, 50.00, '2024-06-25 09:00:00', '2024-06-25 14:00:00', 4),
    (3, 1, 1, '2024-06-26', 6.00, 150.00, 300.00, '2024-06-26 13:00:00', '2024-06-26 19:00:00', 5),
    (3, 3, 2, '2024-06-26', 6.00, 100.00, 150.00, '2024-06-26 13:00:00', '2024-06-26 19:00:00', 4),
    (3, 7, 3, '2024-06-26', 7.00, 50.00, 100.00, '2024-06-26 13:00:00', '2024-06-26 20:00:00', 5);
GO
