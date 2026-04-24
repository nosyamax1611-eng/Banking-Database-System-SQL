WITH 
  L0 AS (SELECT 1 AS c UNION ALL SELECT 1), 
  L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B), 
  L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B), 
  L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B), 
  L4 AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B), 
  Nums AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ID FROM L4)
INSERT INTO Customers (
    CustomerID, FullName, DOB, Email, PhoneNumber, Address, 
    NationalID, TaxID, EmploymentStatus, AnnualIncome, CreatedAt, UpdatedAt
)
SELECT TOP 10000
    ID,
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1, 'Ivan', 'Dmitry', 'Alexey', 'Maria', 'Elena') + ' ' + 
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1, 'Ivanov', 'Petrov', 'Sidorov', 'Kuznetsov', 'Smirnov'),
    
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 16000, '1960-01-01'),
    
    'user' + CAST(ID AS VARCHAR(10)) + '@bank-mail' + CAST(ID % 5 AS VARCHAR) + '.com',
    
    '+7-' + CAST(900 + (ABS(CHECKSUM(NEWID())) % 100) AS VARCHAR) + '-' + CAST(1000000 + (ABS(CHECKSUM(NEWID())) % 9000000) AS VARCHAR),
    
    'Street ' + CAST(ABS(CHECKSUM(NEWID())) % 500 AS VARCHAR) + ', Build ' + CAST(ID AS VARCHAR),
    
    'NID' + RIGHT('000000' + CAST(ID AS VARCHAR(10)), 7) + CAST(ABS(CHECKSUM(NEWID())) % 100 AS VARCHAR),
    'TAX' + RIGHT('000000' + CAST(ID AS VARCHAR(10)), 7) + CAST(ABS(CHECKSUM(NEWID())) % 100 AS VARCHAR),
    
    CHOOSE(ABS(CHECKSUM(NEWID())) % 4 + 1, 'Employed', 'Self-Employed', 'Unemployed', 'Retired'),
    
    (ABS(CHECKSUM(NEWID())) % 130000) + 20000,
    
    GETDATE(),
    GETDATE()
FROM Nums;

INSERT INTO Branches (BranchID, BranchName, Address, City, State, Country, ManagerID, ContactNumber)
VALUES 
(1, 'Central Plaza Branch', '101 Main St', 'New York', 'NY', 'USA', 101, '+1-212-555-0101'),
(2, 'Silicon Valley Branch', '500 Innovation Way', 'Palo Alto', 'CA', 'USA', 102, '+1-650-555-0202'),
(3, 'Lakeview Branch', '77 Sunset Blvd', 'Chicago', 'IL', 'USA', 103, '+1-312-555-0303'),
(4, 'Gateway Arch Branch', '200 Broadway', 'St. Louis', 'MO', 'USA', 104, '+1-314-555-0404'),
(5, 'Everglades Branch', '45 Ocean Drive', 'Miami', 'FL', 'USA', 105, '+1-305-555-0505'),
(6, 'Rocky Mountain Branch', '900 Peak St', 'Denver', 'CO', 'USA', 106, '+1-303-555-0606'),
(7, 'Pacific Harbor Branch', '1200 Marina Way', 'Seattle', 'WA', 'USA', 107, '+1-206-555-0707'),
(8, 'Lone Star Branch', '300 Texan Ave', 'Houston', 'TX', 'USA', 108, '+1-713-555-0808'),
(9, 'Liberty Bell Branch', '55 Independence Sq', 'Philadelphia', 'PA', 'USA', 109, '+1-215-555-0909'),
(10, 'Desert Sun Branch', '888 Phoenix Way', 'Phoenix', 'AZ', 'USA', 110, '+1-602-555-1010');

WITH 
  L0 AS (SELECT 1 AS c UNION ALL SELECT 1), 
  L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B), 
  L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B), 
  L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B), 
  L4 AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B), 
  Nums AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ID FROM L4)
INSERT INTO Accounts (
    AccountID, CustomerID, AccountType, Balance, Currency, Status, BranchID, CreatedDate
)
SELECT TOP 10000
    ID,
    ID,
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1, 'Savings', 'Checking', 'Business'),
    CAST((ABS(CHECKSUM(NEWID())) % 100000) + (ABS(CHECKSUM(NEWID())) % 100 / 100.0) AS DECIMAL(15,2)), 
    'USD',
    'Active',
    (ID % 10) + 1, 
    DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 365), GETDATE()) 
FROM Nums;

SET NOCOUNT ON;
DECLARE @RowsInserted INT = 0;
DECLARE @TotalRows INT = 20000;
DECLARE @BatchSize INT = 2000;

WHILE @RowsInserted < @TotalRows
BEGIN
    INSERT INTO Transactions (
        TransactionID, AccountID, TransactionType, Amount, Currency, Date, Status, ReferenceNo
    )
    SELECT TOP (@BatchSize)
        @RowsInserted + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
        ((@RowsInserted + ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) % 10000) + 1,
        CHOOSE(CAST(ABS(CHECKSUM(NEWID())) % 4 + 1 AS INT), 'Deposit', 'Withdrawal', 'Transfer', 'Payment'),
        CAST((ABS(CHECKSUM(NEWID())) % 5000) + 1 AS DECIMAL(10,2)),
        'USD',
        DATEADD(MINUTE, - (ABS(CHECKSUM(NEWID())) % 43200), GETDATE()),
        'Active',
        'REF-' + CAST(ABS(CHECKSUM(NEWID())) % 1000000 AS VARCHAR) + CAST(@RowsInserted AS VARCHAR)
    FROM sys.all_columns a CROSS JOIN sys.all_columns b;

    SET @RowsInserted = @RowsInserted + @BatchSize;
    PRINT 'Inserted ' + CAST(@RowsInserted AS VARCHAR) + ' rows...';
END

WITH 
  L0 AS (SELECT 1 AS c UNION ALL SELECT 1), 
  L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B), 
  L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B), 
  L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B), 
  L4 AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B), 
  Nums AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ID FROM L4)
INSERT INTO Loans (
    LoanID, CustomerID, LoanType, Amount, InterestRate, StartDate, EndDate, Status
)
SELECT TOP 5000 
    ID,
    (ID % 4000) + 1,
    
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1, 'Personal', 'Mortgage', 'Auto'),
    
    CAST((ABS(CHECKSUM(NEWID())) % 495000) + 5000 AS DECIMAL(15,2)),
    
    CAST((ABS(CHECKSUM(NEWID())) % 12) + 3.5 AS DECIMAL(5,2)),
    
    DATEADD(MONTH, - (ID % 24), GETDATE()), 
    DATEADD(MONTH, (ID % 60) + 12, GETDATE()), 
    'Active'
FROM Nums;
