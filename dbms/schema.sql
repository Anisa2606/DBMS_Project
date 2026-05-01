-- =========================
-- FREELANCEHUB DATABASE
-- MYSQL VERSION
-- =========================

CREATE DATABASE freelancehub;
USE freelancehub;

-- =========================
-- USER TABLE
-- =========================
CREATE TABLE `USER` (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Role VARCHAR(20) NOT NULL
);

-- =========================
-- PROJECT TABLE
-- =========================
CREATE TABLE PROJECT (
    Project_ID INT AUTO_INCREMENT PRIMARY KEY,
    Client_ID INT,
    Title VARCHAR(100) NOT NULL,
    Budget INT,
    Deadline DATE,
    FOREIGN KEY (Client_ID) REFERENCES `USER`(User_ID)
);

-- =========================
-- BID TABLE
-- =========================
CREATE TABLE BID (
    Bid_ID INT AUTO_INCREMENT PRIMARY KEY,
    Project_ID INT,
    Freelancer_ID INT,
    Bid_Amount INT,
    FOREIGN KEY (Project_ID) REFERENCES PROJECT(Project_ID),
    FOREIGN KEY (Freelancer_ID) REFERENCES `USER`(User_ID)
);

-- =========================
-- CONTRACT TABLE
-- =========================
CREATE TABLE CONTRACT (
    Contract_ID INT AUTO_INCREMENT PRIMARY KEY,
    Project_ID INT,
    Freelancer_ID INT,
    Total_Amount INT,
    FOREIGN KEY (Project_ID) REFERENCES PROJECT(Project_ID),
    FOREIGN KEY (Freelancer_ID) REFERENCES `USER`(User_ID)
);

-- =========================
-- MILESTONE TABLE
-- =========================
CREATE TABLE MILESTONE (
    Milestone_ID INT AUTO_INCREMENT PRIMARY KEY,
    Contract_ID INT,
    Amount INT,
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (Contract_ID) REFERENCES CONTRACT(Contract_ID)
);

-- =========================
-- ESCROW TABLE
-- =========================
CREATE TABLE ESCROW (
    Escrow_ID INT AUTO_INCREMENT PRIMARY KEY,
    Contract_ID INT,
    Total_Deposited INT,
    Remaining_Balance INT,
    FOREIGN KEY (Contract_ID) REFERENCES CONTRACT(Contract_ID)
);

-- =========================
-- INSERT DATA
-- =========================
INSERT INTO `USER` (Name, Email, Password, Role) VALUES
('Anisa','anisa@gmail.com','123','Client'),
('Akshat','akshat@gmail.com','123','Freelancer');

INSERT INTO PROJECT (Client_ID, Title, Budget, Deadline) VALUES
(1,'Website Development',5000,'2026-05-10');

INSERT INTO BID (Project_ID, Freelancer_ID, Bid_Amount) VALUES
(1,2,4500);

INSERT INTO CONTRACT (Project_ID, Freelancer_ID, Total_Amount) VALUES
(1,2,4500);

INSERT INTO ESCROW (Contract_ID, Total_Deposited, Remaining_Balance) VALUES
(1,4500,4500);

INSERT INTO MILESTONE (Contract_ID, Amount, Status) VALUES
(1,2000,'Pending'),
(1,2500,'Pending');

-- =========================
-- TRIGGER
-- =========================
DELIMITER //

CREATE TRIGGER release_payment
AFTER UPDATE ON MILESTONE
FOR EACH ROW
BEGIN
   IF NEW.Status = 'Approved' THEN
       UPDATE ESCROW
       SET Remaining_Balance = Remaining_Balance - NEW.Amount
       WHERE Contract_ID = NEW.Contract_ID;
   END IF;
END //

DELIMITER ;

-- =========================
-- STORED PROCEDURE
-- =========================
DELIMITER //

CREATE PROCEDURE CreateContract(
   IN p_project INT,
   IN p_freelancer INT,
   IN p_amount INT
)
BEGIN
   INSERT INTO CONTRACT(Project_ID, Freelancer_ID, Total_Amount)
   VALUES(p_project, p_freelancer, p_amount);
END //

DELIMITER ;

-- =========================
-- FUNCTION
-- =========================
DELIMITER //

CREATE FUNCTION GetBalance(p_contract INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE bal INT;

    SELECT Remaining_Balance INTO bal
    FROM ESCROW
    WHERE Contract_ID = p_contract;

    RETURN bal;
END //

DELIMITER ;

-- =========================
-- SAMPLE QUERIES
-- =========================

SELECT * FROM `USER`;
SELECT * FROM PROJECT;
SELECT * FROM BID;
SELECT * FROM CONTRACT;
SELECT * FROM MILESTONE;
SELECT * FROM ESCROW;

-- JOIN
SELECT P.Project_ID, P.Title, U.Name
FROM PROJECT P
JOIN `USER` U ON P.Client_ID = U.User_ID;

-- AGGREGATE
SELECT SUM(Remaining_Balance) FROM ESCROW;

-- UPDATE (Trigger Test)
UPDATE MILESTONE
SET Status = 'Approved'
WHERE Milestone_ID = 1;