/*
================================================================================
SCRIPT: Large Scale Data Generator for AirlineSourceDB (V1)
DESCRIPTION: This script programmatically generates a large number of records
             for the Flight, Ticket, and Booking tables.

HOW TO USE:ّ
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
-- CONFIGURATION
-- Change this value to control how many new flights are created.
-- Each flight will have a random number of tickets.
-- Default is 1,000. For ~1M tickets, you might set this around 10,000.
DECLARE @NumberOfFlightsToGenerate INT = 10000;
-- ===============================================================================


PRINT 'Starting data generation process for ' + CAST(@NumberOfFlightsToGenerate AS VARCHAR) + ' flights...';
PRINT 'Each flight will have a realistic number of tickets/bookings.';

-- Declare variables for the main loop
DECLARE @FlightCounter INT = 0;
DECLARE @StartTime DATETIME = GETDATE();

-- **FIX**: Declare variables to manually manage Primary Keys
DECLARE @NextFlightID INT;
DECLARE @NextTicketID INT;
DECLARE @NextBookingID INT;

-- Declare variables for the inner ticket loop
DECLARE @TicketCounter INT;
DECLARE @TicketsToGenerateForFlight INT;
DECLARE @TotalRevenueForFlight DECIMAL(15, 2);

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

-- **FIX**: Initialize the next available IDs by finding the current MAX ID in each table.
SELECT @NextFlightID = ISNULL(MAX(Flight_ID), 0)
FROM Flight;
SELECT @NextTicketID = ISNULL(MAX(Ticket_ID), 0)
FROM Ticket;
SELECT @NextBookingID = ISNULL(MAX(Booking_ID), 0)
FROM Booking;

PRINT 'Starting Flight ID: ' + CAST(@NextFlightID + 1 AS VARCHAR);
PRINT 'Starting Ticket ID: ' + CAST(@NextTicketID + 1 AS VARCHAR);
PRINT 'Starting Booking ID: ' + CAST(@NextBookingID + 1 AS VARCHAR);

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
        SET @TicketsToGenerateForFlight = CAST(RAND() * (@AircraftCapacity * 0.4) + (@AircraftCapacity * 0.5) AS INT);
        IF @TicketsToGenerateForFlight > @AircraftCapacity SET @TicketsToGenerateForFlight = @AircraftCapacity;

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

        INSERT INTO Ticket
            (Ticket_ID, Flight_ID, Class_ID, Ticket_Status_ID, Price, Discount, Seat_Number)
        VALUES
            ( @NextTicketID, @NextFlightID, @RandomClassID, 1, @FinalPrice, 0, @SeatNumber );

        INSERT INTO Booking
            (Booking_ID, Ticket_ID, Customer_ID, Payment_Method_ID, Booking_Date, Total_Amount, Cancellation_Reason_ID, Cancellation_Fee)
        VALUES
            (
                @NextBookingID, @NextTicketID, @RandomCustomerID, @RandomPaymentMethodID,
                DATEADD(day, - (CAST(RAND() * 30 + 1 AS INT)), @ScheduledDeparture),
                @FinalPrice, NULL, NULL
            );

        SET @TotalRevenueForFlight = @TotalRevenueForFlight + @FinalPrice;
        SET @TicketCounter = @TicketCounter + 1;
    END

        -- 4. Now, update the flight with the final passenger count and revenue
        ----------------------------------------------------------------
        UPDATE Flight
        SET Passenger_Count = @TicketsToGenerateForFlight,
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
GO

select * from Ticket;