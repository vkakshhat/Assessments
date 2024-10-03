--creating and using a database named "carRental" for a Car Rental System
create database carRental;
use carRental;

--creating the vehicle table
CREATE TABLE Vehicle (
vehicleID INT PRIMARY KEY,
make VARCHAR(50),
model VARCHAR(50),
year INT,
dailyRate DECIMAL(10, 2),
status BIT, -- 1 = available, 0 = notAvailable
passengerCapacity INT,
engineCapacity INT);

--inserting values into the Vehicle table
INSERT INTO Vehicle (vehicleID, make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
VALUES
(1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500);

--creating the customer table
CREATE TABLE Customer (
customerID INT PRIMARY KEY,
firstName VARCHAR(50),
lastName VARCHAR(50),
email VARCHAR(100),
phoneNumber VARCHAR(20));

--inserting values into the Customer table
INSERT INTO Customer (customerID, firstName, lastName, email, phoneNumber)
VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

--creating the Lease table
CREATE TABLE Lease (
leaseID INT PRIMARY KEY,
vehicleID INT,
customerID INT,
startDate DATE,
endDate DATE,
leaseType VARCHAR(10), -- 'Daily' or 'Monthly'
FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID),
FOREIGN KEY (customerID) REFERENCES Customer(customerID));

--inserting values into the Lease table
INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, leaseType)
VALUES
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');

--creating the payment table
CREATE TABLE Payment (
paymentID INT PRIMARY KEY,
leaseID INT,
transactionDate DATE,
amount DECIMAL(10, 2),
FOREIGN KEY (leaseID) REFERENCES Lease(leaseID));

--inserting values into the Payment table
INSERT INTO Payment (paymentID, leaseID, transactionDate, amount)
VALUES
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00);

--Queries
--1. Update the daily rate for a Mercedes car to 68.
UPDATE Vehicle
SET dailyRate = 68
WHERE make = 'Mercedes';

--2. Delete a specific customer and all associated leases and payments.
DELETE FROM Payment
WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID = 3);
DELETE FROM Lease
WHERE customerID = 3;
DELETE FROM Customer
WHERE customerID = 3;

--3. Rename the "paymentDate" column in the Payment table to "transactionDate".
EXEC sp_rename 'Payment.paymentDate', 'transactionDate', 'COLUMN';

--4. Find a specific customer by email.
SELECT *
FROM Customer
WHERE email = 'michael@example.com';

--5. Get active leases for a specific customer.
SELECT *
FROM Lease
WHERE customerID = 7
AND endDate > GETDATE();

--6. Find all payments made by a customer with a specific phone number.
SELECT c.*, p.*
FROM Payment p
JOIN Lease l ON p.leaseID = l.leaseID
JOIN Customer c ON l.customerID = c.customerID
WHERE c.phoneNumber = '555-123-4567';

--7. Calculate the average daily rate of all available cars.
SELECT AVG(dailyRate) AS avgDailyRate
FROM Vehicle
WHERE status = 1;

--8. Find the car with the highest daily rate.
SELECT TOP 1 *
FROM Vehicle
ORDER BY dailyRate DESC;

--9. Retrieve all cars leased by a specific customer.
SELECT l.leaseID, v.*
FROM Vehicle v
JOIN Lease l ON v.vehicleID = l.vehicleID
WHERE l.customerID = 8;

--10. Find the details of the most recent lease.
SELECT TOP 1 *
FROM Lease
ORDER BY endDate DESC;

--11. List all payments made in the year 2023.
SELECT *
FROM Payment
WHERE YEAR(transactionDate) = 2023;

--12. Retrieve customers who have not made any payments.
SELECT c.*
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
WHERE p.paymentID IS NULL;

--13. Retrieve Car Details and Their Total Payments.
SELECT v.*, SUM(p.amount) AS totalPayments
FROM Vehicle v
JOIN Lease l ON v.vehicleID = l.vehicleID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.vehicleID, v.make, v.model, v.year, v.dailyRate, v.status, v.passengerCapacity, v.engineCapacity;

--14. Calculate Total Payments for Each Customer.
SELECT c.customerID, c.firstName, c.lastName, SUM(p.amount) AS totalPayments
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName;

--15. List Car Details for Each Lease.
SELECT v.*,l.leaseID, l.startDate, l.endDate,l.leaseType
FROM Lease l
JOIN Vehicle v ON l.vehicleID = v.vehicleID;

--16. Retrieve Details of Active Leases with Customer and Car Information.
SELECT c.*,v.*, l.startDate, l.endDate,l.leaseType
FROM Lease l
JOIN Customer c ON l.customerID = c.customerID
JOIN Vehicle v ON l.vehicleID = v.vehicleID
WHERE l.endDate > GETDATE();

--17. Find the Customer Who Has Spent the Most on Leases.
SELECT TOP 1 c.*, SUM(p.amount) AS totalSpent
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName, c.email, c.phoneNumber
ORDER BY totalSpent DESC;

--18. List All Cars with Their Current Lease Information.
SELECT v.*, l.*
FROM Vehicle v
LEFT JOIN Lease l ON v.vehicleID = l.vehicleID
LEFT JOIN Customer c ON l.customerID = c.customerID;