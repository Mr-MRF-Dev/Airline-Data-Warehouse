/*
================================================================================
SCRIPT: Large Scale Data Generator for AirlineSourceDB (V3)
DESCRIPTION: This script programmatically generates a large number of records
             for the Flight, Ticket, Booking, Flight_Crew, and Cargo tables.

             V3 Changes:
             - Added logic to generate Flight_Crew for every flight, assigning
               pilots and cabin crew.
             - Added logic to generate Cargo for a random percentage of flights.
             - Added PK management for the Cargo table.

HOW TO USE:
1.  Run the initial scripts to create and populate the database schema.
2.  Adjust the @NumberOfFlightsToGenerate variable below to your desired number.
3.  Execute this script.

Created BY: Google Gemini :)
================================================================================
*/
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


SET NOCOUNT ON;

-- ===============================================================================
-- DEPENDENCY VALIDATION
-- Check if core tables have data before starting generation.
-- ===============================================================================
PRINT 'Validating dependencies...';

IF NOT EXISTS (SELECT 1 FROM Route) BEGIN PRINT 'ERROR: Prerequisite table [Route] is empty. Please insert data before running this script.'; RETURN; END
IF NOT EXISTS (SELECT 1 FROM Aircraft) BEGIN PRINT 'ERROR: Prerequisite table [Aircraft] is empty. Please insert data before running this script.'; RETURN; END
IF NOT EXISTS (SELECT 1 FROM Customer) BEGIN PRINT 'ERROR: Prerequisite table [Customer] is empty. Please insert data before running this script.'; RETURN; END
IF NOT EXISTS (SELECT 1 FROM Class) BEGIN PRINT 'ERROR: Prerequisite table [Class] is empty. Please insert data before running this script.'; RETURN; END
IF NOT EXISTS (SELECT 1 FROM Payment_Method) BEGIN PRINT 'ERROR: Prerequisite table [Payment_Method] is empty. Please insert data before running this script.'; RETURN; END
IF NOT EXISTS (SELECT 1 FROM Crew) BEGIN PRINT 'ERROR: Prerequisite table [Crew] is empty. Please insert data before running this script.'; RETURN; END
IF NOT EXISTS (SELECT 1 FROM Crew_Role) BEGIN PRINT 'ERROR: Prerequisite table [Crew_Role] is empty. Please insert data before running this script.'; RETURN; END
IF NOT EXISTS (SELECT 1 FROM Booking_Cancellation_Reason) BEGIN PRINT 'ERROR: Prerequisite table [Booking_Cancellation_Reason] is empty. Please insert data before running this script.'; RETURN; END
IF NOT EXISTS (SELECT 1 FROM Cargo_Type) BEGIN PRINT 'ERROR: Prerequisite table [Cargo_Type] is empty. Please insert data before running this script.'; RETURN; END
IF NOT EXISTS (SELECT 1 FROM Flight_Status) BEGIN PRINT 'ERROR: Prerequisite table [Flight_Status] is empty. Please insert data before running this script.'; RETURN; END

PRINT 'All dependencies are valid.';
GO


-- ===============================================================================
-- CONFIGURATION
-- Change this value to control how many new flights are created.
-- Each flight will have a random number of tickets.
-- Default is 1,000. For ~1M tickets, you might set this around 10,000.
DECLARE @NumberOfFlightsToGenerate INT = 10000;
-- ===============================================================================


PRINT 'Starting data generation process for ' + CAST(@NumberOfFlightsToGenerate AS VARCHAR) + ' flights...';
PRINT 'Each flight will have tickets, cancellations, crew, and a chance of cargo.';

-- Declare variables for the main loop
DECLARE @FlightCounter INT = 0;
DECLARE @StartTime DATETIME = GETDATE();

-- Declare variables to manually manage Primary Keys
DECLARE @NextFlightID INT;
DECLARE @NextTicketID INT;
DECLARE @NextBookingID INT;
DECLARE @NextCargoID INT;
-- **NEW**

-- Declare variables for the inner ticket loop
DECLARE @TicketCounter INT;
DECLARE @TicketsToGenerateForFlight INT;
DECLARE @TotalRevenueForFlight DECIMAL(15, 2);
DECLARE @ConfirmedPassengerCount INT;

-- Variables for cancellation logic
DECLARE @CancellationsToGenerate INT;
DECLARE @CancellationCounter INT;
DECLARE @RandomCancellationReasonID INT;
DECLARE @CancellationFee DECIMAL(10, 2);

-- **NEW**: Variables for Flight Crew logic
DECLARE @CrewCounter INT;
DECLARE @CaptainID INT, @FirstOfficerID INT;
DECLARE @CabinCrewToGenerate INT;
DECLARE @RandomCrewID INT, @RandomCrewRoleID INT;

-- **NEW**: Variables for Cargo logic
DECLARE @CargoCounter INT;
DECLARE @CargoItemsToGenerate INT;
DECLARE @RandomCargoTypeID INT;
DECLARE @RandomTicketForCargo INT;


-- Declare variables to hold data for each iteration
DECLARE @RandomAircraftID INT;
DECLARE @AircraftCapacity INT;
DECLARE @RandomRouteID INT;
DECLARE @RandomCustomerID INT;
DECLARE @RandomClassID INT;
DECLARE @RandomPaymentMethodID INT;
DECLARE @RandomFlightStatusID INT;

DECLARE @FlightDate DATE;
DECLARE @ScheduledDeparture DATETIME;
DECLARE @ScheduledArrival DATETIME;
DECLARE @FlightDurationMinutes INT;
DECLARE @BasePrice DECIMAL(10, 2);
DECLARE @PriceMultiplier DECIMAL(4, 2);
DECLARE @FinalPrice DECIMAL(10, 2);
DECLARE @SeatNumber VARCHAR(10);
DECLARE @SeatRow INT;
DECLARE @SeatLetter CHAR(1);
DECLARE @FuelCost DECIMAL(15, 2);
DECLARE @ServiceCost DECIMAL(15, 2);

-- Initialize the next available IDs by finding the current MAX ID in each table.
SELECT @NextFlightID = ISNULL(MAX(Flight_ID), 0)
FROM Flight;
SELECT @NextTicketID = ISNULL(MAX(Ticket_ID), 0)
FROM Ticket;
SELECT @NextBookingID = ISNULL(MAX(Booking_ID), 0)
FROM Booking;
SELECT @NextCargoID = ISNULL(MAX(Cargo_ID), 0)
FROM Cargo;
-- **NEW**

PRINT 'Starting Flight ID: ' + CAST(@NextFlightID + 1 AS VARCHAR);
PRINT 'Starting Ticket ID: ' + CAST(@NextTicketID + 1 AS VARCHAR);
PRINT 'Starting Booking ID: ' + CAST(@NextBookingID + 1 AS VARCHAR);
PRINT 'Starting Cargo ID: ' + CAST(@NextCargoID + 1 AS VARCHAR);
-- **NEW**

-- Main loop to create flights
WHILE @FlightCounter < @NumberOfFlightsToGenerate
BEGIN
    BEGIN TRY
        -- 1. Generate data for a single flight
        ----------------------------------------------------------------
        SELECT TOP 1
        @RandomAircraftID = Aircraft_ID, @AircraftCapacity = Passenger_Capacity
    FROM Aircraft
    WHERE Is_Active = 1
    ORDER BY NEWID();
        SELECT TOP 1
        @RandomRouteID = Route_ID, @FlightDurationMinutes = Flight_Duration_Minutes, @BasePrice = Distance_KM * (RAND() * 0.4 + 0.2)
    FROM Route
    WHERE Is_Active = 1
    ORDER BY NEWID();

        IF @RandomAircraftID IS NULL OR @RandomRouteID IS NULL
        BEGIN
        PRINT 'Warning: Could not find an active Aircraft or Route. Skipping flight generation #' + CAST(@FlightCounter + 1 AS VARCHAR);
        SET @FlightCounter = @FlightCounter + 1;
        CONTINUE;
    END

        SELECT TOP 1
        @RandomFlightStatusID = Flight_Status_ID
    FROM Flight_Status
    WHERE Flight_Status_ID IN (1, 2, 3, 7)
    ORDER BY NEWID();

        SET @FlightDate = DATEADD(day, CAST(RAND() * 365 as INT), '2025-01-01');
        SET @ScheduledDeparture = DATEADD(minute, CAST(RAND() * 1440 as INT), CAST(@FlightDate AS DATETIME));
        SET @ScheduledArrival = DATEADD(minute, @FlightDurationMinutes, @ScheduledDeparture);

        SET @NextFlightID = @NextFlightID + 1;

        BEGIN TRANSACTION;

        -- 2. INSERT the new Flight record
        ----------------------------------------------------------------
        SET @FuelCost = @FlightDurationMinutes * (RAND() * 40 + 80);
        SET @ServiceCost = @AircraftCapacity * (RAND() * 5 + 10);

        INSERT INTO Flight
        (Flight_ID, Flight_Number, Flight_Date, Aircraft_ID, Route_ID, Scheduled_Departure, Scheduled_Arrival, Passenger_Count, Revenue, Fuel_Cost, Service_Cost, Flight_Status_ID)
    VALUES
        (
            @NextFlightID,
            'FN' + CAST(ABS(CHECKSUM(NEWID())) % 9000 + 1000 AS VARCHAR),
            @FlightDate, @RandomAircraftID, @RandomRouteID, @ScheduledDeparture, @ScheduledArrival,
            0, 0.00,
            @FuelCost, @ServiceCost,
            @RandomFlightStatusID
        );

        -- 3. Inner loop to create tickets and bookings for this flight
        ----------------------------------------------------------------
        SET @TicketCounter = 0;
        SET @TotalRevenueForFlight = 0.00;
        SET @ConfirmedPassengerCount = 0;
        SET @TicketsToGenerateForFlight = CAST(RAND() * (@AircraftCapacity * 0.4) + (@AircraftCapacity * 0.5) AS INT);
        IF @TicketsToGenerateForFlight > @AircraftCapacity SET @TicketsToGenerateForFlight = @AircraftCapacity;

        SET @CancellationsToGenerate = 5 + (ABS(CHECKSUM(NEWID())) % 6);
        IF @CancellationsToGenerate >= @TicketsToGenerateForFlight SET @CancellationsToGenerate = @TicketsToGenerateForFlight - 1;
        SET @CancellationCounter = 0;

        WHILE @TicketCounter < @TicketsToGenerateForFlight
        BEGIN
        SET @NextTicketID = @NextTicketID + 1;
        SET @NextBookingID = @NextBookingID + 1;

        SELECT TOP 1
            @RandomCustomerID = Customer_ID
        FROM Customer
        WHERE Is_Active = 1
        ORDER BY NEWID();
        SELECT TOP 1
            @RandomClassID = Class_ID, @PriceMultiplier = Base_Price_Multiplier
        FROM Class
        WHERE Is_Active = 1
        ORDER BY NEWID();
        SELECT TOP 1
            @RandomPaymentMethodID = Payment_Method_ID
        FROM Payment_Method
        WHERE Is_Active = 1
        ORDER BY NEWID();

        SET @FinalPrice = @BasePrice * @PriceMultiplier * (RAND() * 0.2 + 0.9);
        SET @SeatRow = @TicketCounter / 6 + 1;
        SET @SeatLetter = CHAR((@TicketCounter % 6) + 65);
        SET @SeatNumber = CAST(@SeatRow AS VARCHAR) + @SeatLetter;

        IF @CancellationCounter < @CancellationsToGenerate
            BEGIN
            SELECT TOP 1
                @RandomCancellationReasonID = Cancellation_ID
            FROM Booking_Cancellation_Reason
            ORDER BY NEWID();
            SET @CancellationFee = @FinalPrice * (RAND() * 0.2 + 0.1);

            INSERT INTO Ticket
                (Ticket_ID, Flight_ID, Class_ID, Ticket_Status_ID, Price, Discount, Seat_Number)
            VALUES
                ( @NextTicketID, @NextFlightID, @RandomClassID, 2, @FinalPrice, 0, @SeatNumber );
            -- Status 2 = Cancelled

            INSERT INTO Booking
                (Booking_ID, Ticket_ID, Customer_ID, Payment_Method_ID, Booking_Date, Total_Amount, Cancellation_Reason_ID, Cancellation_Fee)
            VALUES
                ( @NextBookingID, @NextTicketID, @RandomCustomerID, @RandomPaymentMethodID, DATEADD(day, -(CAST(RAND() * 30 + 1 AS INT)), @ScheduledDeparture), @FinalPrice, @RandomCancellationReasonID, @CancellationFee );

            SET @CancellationCounter = @CancellationCounter + 1;
        END
            ELSE
            BEGIN
            INSERT INTO Ticket
                (Ticket_ID, Flight_ID, Class_ID, Ticket_Status_ID, Price, Discount, Seat_Number)
            VALUES
                ( @NextTicketID, @NextFlightID, @RandomClassID, 1, @FinalPrice, 0, @SeatNumber );
            -- Status 1 = Confirmed

            INSERT INTO Booking
                (Booking_ID, Ticket_ID, Customer_ID, Payment_Method_ID, Booking_Date, Total_Amount, Cancellation_Reason_ID, Cancellation_Fee)
            VALUES
                ( @NextBookingID, @NextTicketID, @RandomCustomerID, @RandomPaymentMethodID, DATEADD(day, -(CAST(RAND() * 30 + 1 AS INT)), @ScheduledDeparture), @FinalPrice, NULL, NULL );

            SET @TotalRevenueForFlight = @TotalRevenueForFlight + @FinalPrice;
            SET @ConfirmedPassengerCount = @ConfirmedPassengerCount + 1;
        END
        SET @TicketCounter = @TicketCounter + 1;
    END

        -- 4. **NEW**: Generate Flight Crew
        ----------------------------------------------------------------
        -- Select one Captain
        SELECT TOP 1
        @CaptainID = Crew_ID
    FROM Crew
    WHERE Crew_Role_Type_ID = 1
    ORDER BY NEWID();
        -- Select a different First Officer
        SELECT TOP 1
        @FirstOfficerID = Crew_ID
    FROM Crew
    WHERE Crew_Role_Type_ID = 1 AND Crew_ID <> @CaptainID
    ORDER BY NEWID();

        IF @CaptainID IS NOT NULL AND @FirstOfficerID IS NOT NULL
        BEGIN
        INSERT INTO Flight_Crew
            (Flight_ID, Crew_ID, Crew_Role_ID, Assignment_Date, Duration_Hours, Hourly_Fee)
        VALUES
            (@NextFlightID, @CaptainID, 1, @FlightDate, @FlightDurationMinutes / 60.0, 150.00);
        INSERT INTO Flight_Crew
            (Flight_ID, Crew_ID, Crew_Role_ID, Assignment_Date, Duration_Hours, Hourly_Fee)
        VALUES
            (@NextFlightID, @FirstOfficerID, 2, @FlightDate, @FlightDurationMinutes / 60.0, 100.00);
    END

        -- Select random cabin crew
        SET @CrewCounter = 0;
        SET @CabinCrewToGenerate = 2 + (ABS(CHECKSUM(NEWID())) % 5); -- 2 to 6 cabin crew
        WHILE @CrewCounter < @CabinCrewToGenerate
        BEGIN
        SELECT TOP 1
            @RandomCrewID = Crew_ID
        FROM Crew
        WHERE Crew_Role_Type_ID = 2
        ORDER BY NEWID();
        SELECT TOP 1
            @RandomCrewRoleID = Crew_Role_ID
        FROM Crew_Role
        WHERE Crew_Role_Type_ID = 2
        ORDER BY NEWID();

        IF @RandomCrewID IS NOT NULL AND NOT EXISTS (SELECT 1
            FROM Flight_Crew
            WHERE Flight_ID = @NextFlightID AND Crew_ID = @RandomCrewID)
            BEGIN
            INSERT INTO Flight_Crew
                (Flight_ID, Crew_ID, Crew_Role_ID, Assignment_Date, Duration_Hours, Hourly_Fee)
            VALUES
                (@NextFlightID, @RandomCrewID, @RandomCrewRoleID, @FlightDate, @FlightDurationMinutes / 60.0, 40.00);
        END
        SET @CrewCounter = @CrewCounter + 1;
    END

        -- 5. **NEW**: Generate Cargo (40% chance)
        ----------------------------------------------------------------
        IF RAND() < 0.4
        BEGIN
        SET @CargoCounter = 0;
        SET @CargoItemsToGenerate = 5 + (ABS(CHECKSUM(NEWID())) % 16);
        -- 5 to 20 cargo items
        WHILE @CargoCounter < @CargoItemsToGenerate
            BEGIN
            SET @NextCargoID = @NextCargoID + 1;
            SELECT TOP 1
                @RandomCargoTypeID = Cargo_Type_ID
            FROM Cargo_Type
            ORDER BY NEWID();
            -- Find a random confirmed ticket on this flight to associate the cargo with
            SELECT TOP 1
                @RandomTicketForCargo = Ticket_ID
            FROM Ticket
            WHERE Flight_ID = @NextFlightID AND Ticket_Status_ID = 1
            ORDER BY NEWID();

            IF @RandomTicketForCargo IS NOT NULL
                BEGIN
                INSERT INTO Cargo
                    (Cargo_ID, Cargo_Status_ID, Ticket_ID, Flight_ID, Cargo_Type_ID, Weight_KG, Volume_CM3, Declared_Value, Cargo_Delivery_Date)
                VALUES
                    (@NextCargoID, 3, @RandomTicketForCargo, @NextFlightID, @RandomCargoTypeID, RAND()*200, RAND()*10000, RAND()*5000, DATEADD(day, 1, @FlightDate));
            -- Status 3 = Loaded onto Aircraft
            END
            SET @CargoCounter = @CargoCounter + 1;
        END
    END

        -- 6. Update the flight with the final passenger count and revenue
        ----------------------------------------------------------------
        UPDATE Flight
        SET Passenger_Count = @ConfirmedPassengerCount,
            Revenue = @TotalRevenueForFlight
        WHERE Flight_ID = @NextFlightID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Error on flight generation loop #' + CAST(@FlightCounter + 1 AS VARCHAR) + ' for planned FlightID ' + CAST(@NextFlightID AS VARCHAR) + ': ' + ERROR_MESSAGE();
    END CATCH

    SET @FlightCounter = @FlightCounter + 1;

    -- Provide progress update every 100 flights
    IF @FlightCounter % 100 = 0
    BEGIN
        PRINT CAST(@FlightCounter AS VARCHAR) + ' flights generated...';
    END
END

DECLARE @EndTime DATETIME = GETDATE();
PRINT '---------------------------------------------------------';
PRINT 'Data generation complete.';
PRINT 'Total flights generated: ' + CAST(@FlightCounter AS VARCHAR);
PRINT 'Start Time: ' + CONVERT(VARCHAR, @StartTime, 120);
PRINT 'End Time:   ' + CONVERT(VARCHAR, @EndTime, 120);
PRINT 'Total Duration (seconds): ' + CAST(DATEDIFF(second, @StartTime, @EndTime) AS VARCHAR);

-- ===============================================================================
-- FINAL ROW COUNT VERIFICATION
-- ===============================================================================
PRINT '---------------------------------------------------------';
PRINT 'Calculating final table row counts...';
PRINT '---------------------------------------------------------';

DECLARE @RowCount INT;

SELECT @RowCount = COUNT(*)
FROM Aircraft;
PRINT 'Aircraft: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Airport;
PRINT 'Airport: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Route;
PRINT 'Route: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Loyalty_Tier;
PRINT 'Loyalty_Tier: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Customer;
PRINT 'Customer: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Class;
PRINT 'Class: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Payment_Method;
PRINT 'Payment_Method: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Cargo_Type;
PRINT 'Cargo_Type: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Employee;
PRINT 'Employee: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Crew_Role_Type;
PRINT 'Crew_Role_Type: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Crew_Role;
PRINT 'Crew_Role: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Crew;
PRINT 'Crew: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Technician;
PRINT 'Technician: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Maintenance_Type;
PRINT 'Maintenance_Type: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Flight_Status;
PRINT 'Flight_Status: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Booking_Cancellation_Reason;
PRINT 'Booking_Cancellation_Reason: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Ticket_Status;
PRINT 'Ticket_Status: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Cargo_Status;
PRINT 'Cargo_Status: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Maintenance;
PRINT 'Maintenance: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Feedback;
PRINT 'Feedback: ' + CAST(@RowCount AS VARCHAR(20));

PRINT '---------------------------------------------------------';
PRINT '--- Generated Data ---';
PRINT '---------------------------------------------------------';

SELECT @RowCount = COUNT(*)
FROM Flight;
PRINT 'Flight: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Ticket;
PRINT 'Ticket: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Booking;
PRINT 'Booking: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Flight_Crew;
PRINT 'Flight_Crew: ' + CAST(@RowCount AS VARCHAR(20));
SELECT @RowCount = COUNT(*)
FROM Cargo;
PRINT 'Cargo: ' + CAST(@RowCount AS VARCHAR(20));
PRINT '---------------------------------------------------------';
GO
