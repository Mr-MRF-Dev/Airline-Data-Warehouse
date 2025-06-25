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



DELETE FROM Aircraft;
GO
INSERT INTO Aircraft
    (
    Aircraft_ID,
    Registration_Number,
    Model,
    Manufacturer,
    Manufacture_Date,
    Engine_Type,
    Max_Range_KM,
    Passenger_Capacity,
    Fuel_Capacity_Liters,
    Cargo_Capacity_KG,
    Is_Active
    )
VALUES
    (
        1,
        'N12345',
        'Boeing 737-300',
        'Boeing Company',
        '2012-01-20',
        'CFM56-3',
        3500,
        120,
        12700,
        6800,
        0
    ),
    (
        2,
        'N32865',
        'Boeing 737-500',
        'Boeing Company',
        '2016-11-15',
        'CFM56-4',
        4000,
        160,
        16000,
        7200,
        1
    ),
    (
        3,
        'C22439',
        'Boeing 737-700',
        'Boeing Company',
        '2020-05-09',
        'CFM56-7',
        5000,
        180,
        17500,
        7900,
        1
    ),
    (
        4,
        'S44832',
        'Boeing 747-700',
        'Boeing Company',
        '2022-01-12',
        'CFM56-9',
        5200,
        190,
        17600,
        8100,
        1
    ),
    (
        5,
        'F94351',
        'Boeing 747-900',
        'Boeing Company',
        '2022-12-05',
        'CFM56-12',
        5400,
        200,
        17800,
        8300,
        1
    ),
    (
        6,
        'C96582',
        'Airbus A220',
        'Airbus',
        '2011-06-25',
        'PW1100G-JM (GTF)',
        4500,
        108,
        9700,
        5600,
        0
    ),
    (
        7,
        'R49532',
        'Airbus A320',
        'Airbus',
        '2014-10-03',
        'PW1800G-JM (GTF)',
        6000,
        150,
        16500,
        6900,
        0
    ),
    (
        8,
        'N94583',
        'Airbus A350',
        'Airbus',
        '2019-06-06',
        'PW2200G-JM (GTF)',
        7000,
        190,
        17000,
        8000,
        1
    ),
    (
        9,
        'N98721',
        'Airbus A350',
        'Airbus',
        '2021-06-10',
        'PW2200G-JM (GTF)',
        7000,
        190,
        17000,
        8000,
        1
    ),
    (
        10,
        'H96483',
        'Airbus A380',
        'Airbus',
        '2023-11-09',
        'PW2500G-JM (GTF)',
        15000,
        500,
        30000,
        10500,
        1
    );



