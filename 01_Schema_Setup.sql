create database pr1
use pr1

-- Customers
create table Customers(
    CustomerID int primary key,
    FullName varchar(100),
    DOB date not null,
    Email varchar(100) unique,
    PhoneNumber varchar(20),
    Address varchar(100),
    NationalID varchar(50) unique,
    TaxID varchar(50) unique,
    EmploymentStatus varchar(50),
    AnnualIncome decimal(15,2),
    CreatedAt datetime default getdate(),
    UpdatedAt datetime default getdate()
);

-- Departments
create table Departments(
    DepartmentID int primary key,
    DepartmentName varchar(50),
    ManagerID int
);

-- Branches
create table Branches(
    BranchID int primary key,
    BranchName varchar(100) not null,
    Address varchar(200),
    City varchar(100),
    State varchar(100),
    Country varchar(100),
    ManagerID int,
    ContactNumber varchar(20)
);

-- Employees 
CREATE TABLE Employees (
    EmployeeID int primary key,
    BranchID int not null, 
    FullName varchar(50),
    Position varchar(100),  
    Department varchar(100), 
    Salary decimal(18,2),
    HireDate date,
    Status varchar(50),
    foreign key (BranchID) references Branches(BranchID)
);

-- Accounts
create table Accounts(
    AccountID int primary key,
    CustomerID int not null,
    AccountType varchar(50) check (AccountType in('Savings', 'Checking', 'Business')),
    Balance decimal(15,2) not null, 
    Currency char(3) not null,
    Status varchar(50) not null,
    BranchID int,                              
    CreatedDate datetime default getdate(),    
    foreign key(CustomerID) references Customers(CustomerID),
    foreign key(BranchID) references Branches(BranchID)
);

-- Transactions
create table Transactions(
    TransactionID int primary key,
    AccountID int not null,
    TransactionType varchar(50) check (TransactionType in('Deposit', 'Withdrawal', 'Transfer', 'Payment')),
    Amount decimal(10, 2) not null,
    Currency char(3) not null,
    Date datetime default getdate(),
    Status varchar(50) check (Status in('Active', 'Closed', 'Frozen')),
    ReferenceNo varchar(100),
    foreign key (AccountID) references Accounts(AccountID)
);

-- DIGITAL BANKING & PAYMENTS

-- CreditCards
create table CreditCards(
    CardID int primary key,
    CustomerID int not null,
    CardNumber varchar(50) not null,
    CardType varchar(50) not null,
    CVV varchar(3) not null,
    ExpiryDate date not null,
    CreditLimit decimal(18,2) not null, 
    Status varchar(20) not null,
    foreign key (CustomerID) references Customers(CustomerID)
);

-- CreditCardTransactions
create table CreditCardTransactions(
    TransactionID int primary key,
    CardID int not null,
    Merchant varchar(100) not null,
    Amount decimal(15,2),
    Currency char(3) not null,
    Transactiondate datetime not null,
    Status varchar(20) not null,
    foreign key (CardID) references CreditCards(CardID)
);

-- OnlineBankingUsers
create table OnlineBankingUsers(
    UserID int primary key,
    CustomerID int not null,
    Username varchar(50) not null,
    PasswordHash varchar (250) not null,
    LastLogin datetime,
    foreign key (CustomerID) references Customers(CustomerID)
);

-- BillPayments
create table BillPayments(
    PaymentID int primary key,
    CustomerID int not null,
    BillerName varchar(50) not null,
    Amount decimal(15,2),
    Date datetime,
    Status varchar(50),
    foreign key (CustomerID) references Customers(CustomerID)
);

-- MobileBankingTransactions
create table MobileBankingTransactions(
    TransactionId int primary key,
    CustomerID int not null,
    DeviceID int not null,
    AppVersion varchar(55) not null,
    TransactionType varchar(55) not null,
    Amount decimal(15,2),
    Date datetime,
    foreign key (CustomerID) references Customers(CustomerID)
);

-- LOANS & CREDIT

-- Loans
create table Loans(
    LoanID int primary key,
    CustomerID int not null,
    LoanType varchar(70),
    Amount decimal(15,2) check (Amount>0),
    InterestRate decimal(5,2), 
    StartDate date not null,
    EndDate date,
    Status varchar(30),
    foreign key (CustomerID) references Customers(CustomerID)
);

-- LoanPayments
create table LoanPayments(
    PaymentID int primary key, 
    LoanID int not null,
    AmountPaid decimal(15,2) check (AmountPaid>0), 
    PaymentDate date not null, 
    RemainingBalance decimal(15,2),
    foreign key (LoanID) references Loans(LoanID)
);

-- CreditScores
create table CreditScores(
    CustomerID int primary key, 
    CreditScore int, 
    UpdatedAt datetime default getdate() not null, 
    foreign key (CustomerID) references Customers(CustomerID)
);

-- DebtCollection
create table DebtCollection(
    DebtID int primary key, 
    CustomerID int not null,
    AmountDue decimal(15,2) check (AmountDue>0),
    DueDate date not null,
    CollectorAssigned varchar(100),
    foreign key (CustomerID) references Customers(CustomerID)
);

-- COMPLIANCE & RISK MANAGEMENT

-- KYC (Know Your Customer)
create table KYC(
    KYCID int primary key,
    CustomerID int not null,
    DocumentType varchar(50) not null,
    DocumentNumber varchar(50) unique not null,
    VerifiedBy varchar(50),
    foreign key (CustomerID) references Customers(CustomerID)
);

-- FraudDetection
create table FraudDetection(
    FraudID int primary key,
    CustomerID int not null,
    TransactionID int not null,
    RiskLevel varchar(50),
    ReportedDate datetime default getdate() not null, 
    foreign key (CustomerID) references Customers(CustomerID)
);

-- AML (Anti-Money Laundering) Cases
create table AML(
    CaseID int primary key,
    CustomerID int not null,
    CaseType varchar(50) not null,
    Status varchar(50),
    InvestigatorID int,
    foreign key (CustomerID) references Customers(CustomerID)
);

-- RegulatoryReports
create table RegulatoryReports(
    ReportID int primary key,
    ReportType varchar(50) not null, 
    SubmissionDate date not null
);

-- HUMAN RESOURCES & PAYROLL

-- Departments
create table Departments(
    DepartmentID int primary key,
    DepartmentName varchar(100) not null,
    ManagerID int
);

-- Salaries
create table Salaries(
    SalaryID int primary key,
    EmployeeID int not null,
    BaseSalary decimal(15,2) default 0 check (BaseSalary>=0),
    Bonus decimal(15,2) default 0 check (Bonus>=0),
    Deductions decimal(15,2) default 0 check (Deductions>=0), 
    PaymentDate date not null,
    foreign key (EmployeeID) references Employees(EmployeeID)
);

-- EmployeeAttendance
create table EmployeeAttendance (
    AttendanceID int primary key,
    EmployeeID int not null,
    CheckInTime datetime not null,
    CheckOutTime datetime not null,
    TotalHours decimal(5,2) check (TotalHours >= 0),
    foreign key (EmployeeID) references Employees(EmployeeID)
);

-- INVESTMENTS & TREASURY

-- Investments
create table Investments(
    InvestmentID int primary key, 
    CustomerID int not null,
    InvestmentType varchar(50) not null, 
    Amount decimal(15,2) check (Amount>0), 
    ROI decimal(5,2),
    MaturityDate date,
    foreign key (CustomerID) references Customers(CustomerID)
);

-- StockTradingAccounts
create table StockTradingAccounts(
    AccountID int primary key, 
    CustomerID int not null,
    BrokerageFirm varchar(100) not null, 
    TotalInvested decimal(15,2) check (TotalInvested>=0), 
    CurrentValue decimal (15,2) check (CurrentValue>=0),
    foreign key (CustomerID) references Customers(CustomerID)
);

-- ForeignExchange
create table ForeignExchange(
    FXID int primary key, 
    CustomerID int not null,
    CurrencyPair varchar(10) not null, 
    ExchangeRate decimal(15,6) check (ExchangeRate>0), 
    AmountExchanged decimal(15,2) check (AmountExchanged>0),
    foreign key (CustomerID) references Customers(CustomerID)
);

-- INSURANCE & SECURITY

-- InsurancePolicies
create table InsurancePolicies(
    PolicyID int primary key, 
    CustomerID int not null,
    InsuranceType varchar(50) not null, 
    PremiumAmount decimal(15,2) check (PremiumAmount>0), 
    CoverageAmount decimal(15,2) check (CoverageAmount>0),
    foreign key (CustomerID) references Customers(CustomerID)
);

-- Claims
create table Claims(
    ClaimID int primary key,
    PolicyID int not null,
    ClaimAmount decimal(15,2) check (ClaimAmount>0), 
    Status varchar(20), 
    FiledDate date not null,
    foreign key (PolicyID) references InsurancePolicies(PolicyID)
);

-- UserAccessLogs
create table UserAccessLogs(
    LogID int primary key, 
    UserID int not null, 
    ActionType varchar(50) not null, 
    Timestamp datetime default getdate() not null 
);

-- CyberSecurityIncidents
create table CyberSecurityIncidents(
    IncidentID int primary key, 
    AffectedSystem varchar(100) not null, 
    ReportedDate date not null, 
    ResolutionStatus varchar(30)
);

-- MERCHANT SERVICES

-- Merchants
create table Merchants(
    MerchantID int primary key, 
    MerchantName varchar(100) not null, 
    Industry varchar(50), 
    Location varchar(100), 
    CustomerID int,
    foreign key (CustomerID) references Customers(CustomerID)
);

-- MerchantTransactions
create table MerchantTransactions(
    TransactionID int primary key, 
    MerchantID int not null,
    Amount decimal(15,2), 
    PaymentMethod varchar(30), 
    Date date not null, 
    foreign key (MerchantID) references Merchants(MerchantID)
);
