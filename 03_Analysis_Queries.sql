SELECT TOP 3 
    c.CustomerID, 
    c.FullName, 
    SUM(a.Balance) AS TotalBalance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY TotalBalance DESC;

SELECT 
    c.CustomerID, 
    c.FullName, 
    COUNT(l.LoanID) AS ActiveLoanCount
FROM Customers c
JOIN Loans l ON c.CustomerID = l.CustomerID
WHERE l.Status = 'Active'
GROUP BY c.CustomerID, c.FullName
HAVING COUNT(l.LoanID) > 1;

SELECT 
    b.BranchID, 
    b.BranchName, 
    b.City,
    SUM(l.Amount) AS TotalLoanAmount
FROM Branches b
JOIN Accounts a ON b.BranchID = a.BranchID
JOIN Loans l ON a.CustomerID = l.CustomerID
GROUP BY b.BranchID, b.BranchName, b.City
ORDER BY TotalLoanAmount DESC;

INSERT INTO Transactions (TransactionID, AccountID, TransactionType, Amount, Currency, Date, Status, ReferenceNo)
VALUES 
(999991, 1, 'Transfer', 15000, 'USD', GETDATE(), 'Active', 'FRAUD-TEST-1'),
(999992, 1, 'Transfer', 12000, 'USD', DATEADD(MINUTE, 10, GETDATE()), 'Active', 'FRAUD-TEST-2');

SELECT DISTINCT 
    c.CustomerID, 
    c.FullName, 
    t1.TransactionID AS Trans1_ID, 
    t1.Amount AS Amount1,
    t2.TransactionID AS Trans2_ID, 
    t2.Amount AS Amount2,
    t1.Date AS Time1,
    t2.Date AS Time2,
    ABS(DATEDIFF(MINUTE, t1.Date, t2.Date)) AS MinutesBetween
FROM Transactions t1
JOIN Transactions t2 ON t1.AccountID = t2.AccountID AND t1.TransactionID <> t2.TransactionID
JOIN Accounts a ON t1.AccountID = a.AccountID
JOIN Customers c ON a.CustomerID = c.CustomerID
WHERE t1.Amount > 10000 
  AND t2.Amount > 10000
  AND ABS(DATEDIFF(MINUTE, t1.Date, t2.Date)) < 60
ORDER BY MinutesBetween;

CREATE VIEW vw_Bank_Overall_KPI AS
SELECT 
    c.CustomerID,
    c.FullName,
    c.EmploymentStatus,
    b.BranchName,
    b.City AS BranchCity,
    ISNULL(SUM(DISTINCT a.Balance), 0) AS TotalBalance,
    (SELECT COUNT(*) FROM Loans l WHERE l.CustomerID = c.CustomerID AND l.Status = 'Active') AS ActiveLoansCount,
    ISNULL((SELECT SUM(Amount) FROM Loans l WHERE l.CustomerID = c.CustomerID), 0) AS TotalLoanAmount,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM Transactions t1 
            JOIN Transactions t2 ON t1.AccountID = t2.AccountID 
            WHERE a.AccountID = t1.AccountID 
            AND t1.TransactionID <> t2.TransactionID
            AND t1.Amount > 10000 AND t2.Amount > 10000
            AND ABS(DATEDIFF(MINUTE, t1.Date, t2.Date)) < 60
        ) THEN 'Suspicious' ELSE 'Clear' 
    END AS FraudStatus
FROM Customers c
LEFT JOIN Accounts a ON c.CustomerID = a.CustomerID
LEFT JOIN Branches b ON a.BranchID = b.BranchID
GROUP BY c.CustomerID, c.FullName, c.EmploymentStatus, b.BranchName, b.City, a.AccountID;
GO

SELECT * FROM vw_Bank_Overall_KPI;