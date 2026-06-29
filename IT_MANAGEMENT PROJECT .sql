
/*
USE master;  
GO

ALTER DATABASE IT_Management  
COLLATE SQL_Latin1_General_CP1_CI_AS;  
GO

-- Check database collation
SELECT name AS DatabaseName, collation_name
FROM sys.databases
WHERE name = 'IT_Management';
*/

USE IT_Management;
/*
--TABLE
CREATE TABLE dbo.Departments
(
    DepartmentID   INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE dbo.Employees
(
    EmployeeID   INT IDENTITY(1,1) PRIMARY KEY,
    FirstName    VARCHAR(50) NOT NULL,
    LastName     VARCHAR(50) NOT NULL,
    Email        VARCHAR(100) NOT NULL UNIQUE,
    Phone        VARCHAR(30) NULL,
    HireDate     DATE NOT NULL,
    JobTitle     VARCHAR(80) NOT NULL,
    DepartmentID INT NOT NULL,
    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (DepartmentID) REFERENCES dbo.Departments(DepartmentID)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

GO
CREATE TABLE dbo.Projects
(
    ProjectID   INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName VARCHAR(150) NOT NULL UNIQUE,
    StartDate   DATE NOT NULL,
    EndDate     DATE NULL,
    Budget      DECIMAL(18,2) NULL,
    Status      VARCHAR(20) NOT NULL
        CHECK (Status IN ('Planned', 'Active', 'On Hold', 'Completed', 'Cancelled'))
);
GO

-- Bridge table for many-to-many Employee↔️Project
CREATE TABLE dbo.ProjectAssignments
(
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID    INT NOT NULL,
    EmployeeID   INT NOT NULL,
    RoleOnProject VARCHAR(80) NOT NULL,
    AssignedDate DATE NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT UQ_ProjectAssignments UNIQUE(ProjectID, EmployeeID),
    CONSTRAINT FK_ProjectAssignments_Projects FOREIGN KEY (ProjectID)
        REFERENCES dbo.Projects(ProjectID) ON DELETE CASCADE,
    CONSTRAINT FK_ProjectAssignments_Employees FOREIGN KEY (EmployeeID)
        REFERENCES dbo.Employees(EmployeeID) ON DELETE CASCADE
);
GO


CREATE TABLE dbo.Devices
(
    DeviceID     INT IDENTITY(1,1) PRIMARY KEY,
    DeviceTag    VARCHAR(50) NOT NULL UNIQUE,
    DeviceType   VARCHAR(50) NOT NULL,          -- e.g., Laptop, Desktop, Phone, Switch
    BrandModel   VARCHAR(100) NOT NULL,
    PurchaseDate DATE NOT NULL,
    Status       VARCHAR(20) NOT NULL
        CHECK (Status IN ('In Stock', 'Assigned', 'Repair', 'Retired')),
    AssignedTo   INT NULL, -- FK to Employees when assigned
    CONSTRAINT FK_Devices_Employees
        FOREIGN KEY (AssignedTo) REFERENCES dbo.Employees(EmployeeID)
        ON UPDATE NO ACTION ON DELETE SET NULL
);
GO

CREATE TABLE dbo.SoftwareLicenses
(
    LicenseID     INT IDENTITY(1,1) PRIMARY KEY,
    SoftwareName  VARCHAR(120) NOT NULL,
    Vendor        VARCHAR(120) NOT NULL,
    LicenseKey    VARCHAR(120) NOT NULL UNIQUE,
    PurchaseDate  DATE NOT NULL,
    ExpirationDate DATE NOT NULL,
    AssignedTo    INT NULL,
    CONSTRAINT FK_Licenses_Employees
        FOREIGN KEY (AssignedTo) REFERENCES dbo.Employees(EmployeeID)
        ON DELETE SET NULL
);
GO

CREATE TABLE dbo.Tickets
(
    TicketID     INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID   INT NOT NULL,
    ProjectID    INT NULL,
    IssueType    VARCHAR(80) NOT NULL,
    Description  VARCHAR(500) NOT NULL,
    DateReported DATETIME2 NOT NULL DEFAULT (SYSDATETIME()),
    Status       VARCHAR(20) NOT NULL DEFAULT ('Open')
        CHECK (Status IN ('Open', 'In Progress', 'Resolved', 'Closed')),
    CONSTRAINT FK_Tickets_Employees
        FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID),
    CONSTRAINT FK_Tickets_Projects
        FOREIGN KEY (ProjectID) REFERENCES dbo.Projects(ProjectID)
);
GO
*/

/*
-- Departments (10)
INSERT INTO dbo.Departments (DepartmentName) VALUES
('IT Operations'), ('Network Engineering'), ('Security'),
('Development'), ('Data & BI'), ('Help Desk'),
('HR'), ('Finance'), ('Procurement'), ('Facilities');


-- Employees (10)
INSERT INTO dbo.Employees (FirstName, LastName, Email, Phone, HireDate, JobTitle, DepartmentID) VALUES
('Sophea', 'Chan', 'sophea.chan@example.com', '012345678', '2023-02-01', 'IT Manager', 1),
('Dara', 'Lim', 'dara.lim@example.com', '088100200', '2023-03-15', 'Network Engineer', 2),
('Bora', 'Sok', 'bora.sok@example.com', '086222333', '2022-11-21', 'Security Analyst', 3),
('Vannak', 'Kim', 'vannak.kim@example.com', '093889900', '2024-01-12', 'Software Engineer', 4),
('Rith', 'Ly', 'rith.ly@example.com', '015778899', '2021-06-18', 'Data Engineer', 5),
('Linda', 'Phan', 'linda.phan@example.com', '017111222', '2020-10-05', 'Help Desk Lead', 6),
('Nak', 'Heng', N'nak.heng@example.com', '010456789', '2019-09-09', 'HR Officer', 7),
('Sreypov', 'Kong', 'sreypov.kong@example.com', '081555666', '2018-05-25', 'Accountant', 8),
('Piseth', 'Yim', 'piseth.yim@example.com', '089333444', '2022-02-02', 'Procurement Officer', 9),
('Sokunthea','Huor', 'sokunthea.huor@example.com', '099777888', '2017-07-30', 'Facilities Tech', 10),
('Veasna', 'Chea', 'veasna.chea@example.com', '095123456', '2023-05-01', 'Junior Developer', 4),
('Ronan', 'Peak', 'ronan.peak@example.com', '092654321', '2023-08-20', 'Help Desk', 6);

-- Project (10)
INSERT INTO dbo.Projects (ProjectName, StartDate, EndDate, Budget, Status) VALUES
(N'Network Upgrade 2025', '2025-01-10', NULL, 50000, N'Active'),
(N'Identity Management', '2024-11-01', NULL, 35000, N'Active'),
(N'Data Warehouse v2', '2024-07-15', NULL, 80000, N'On Hold'),
(N'Help Desk Revamp', '2025-02-01', NULL, 15000, N'Planned'),
(N'Endpoint Protection', '2024-10-05', '2025-06-30', 40000, N'Completed'),
(N'Cloud Migration Phase 1', '2024-09-01', NULL, 120000, N'Active'),
(N'Facilities IoT', '2025-03-10', NULL, 20000, N'Active'),
(N'License Compliance Audit', '2025-04-01', '2025-05-15', 10000, N'Completed'),
(N'Procurement Portal', '2024-12-10', NULL, 25000, N'Active'),
(N'DR Site Build', '2025-01-25', NULL, 90000, N'Active');

-- ProjectAssignments (10)
INSERT INTO dbo.ProjectAssignments (ProjectID, EmployeeID, RoleOnProject) VALUES
(1, 2, N'Network Lead'), (1, 1, N'Sponsor'), (2, 3, N'Security Reviewer'),
(2, 1, N'Sponsor'), (3, 5, N'Data Architect'), (4, 6, N'Process Owner'),
(5, 3, N'Security Lead'), (6, 4, N'Cloud Engineer'), (7, 10, N'Field Tech'),
(9, 11, N'Frontend Dev');

-- Devices (10)
INSERT INTO dbo.Devices (DeviceTag, DeviceType, BrandModel, PurchaseDate, Status, AssignedTo) VALUES
(N'DEV-001', N'Laptop', N'Dell Latitude 5440', '2024-12-10', N'Assigned', 1),
(N'DEV-002', N'Laptop', N'HP ProBook 450', '2024-11-01', N'Assigned', 4),
(N'DEV-003', N'Desktop', N'Lenovo ThinkCentre M80', '2023-09-15', N'In Stock', NULL),
(N'DEV-004', N'Phone', N'iPhone 13', '2023-06-20', N'Assigned', 6),
(N'DEV-005', N'Switch', N'Cisco C9300', '2022-02-02', N'In Stock', NULL),
(N'DEV-006', N'Laptop', N'ASUS ExpertBook', '2025-01-05', N'Assigned', 11),
(N'DEV-007', N'Desktop', N'HP EliteDesk 800', '2022-12-01', N'Repair', NULL),
(N'DEV-008', N'Phone', N'Samsung S22', '2023-01-15', N'Assigned', 2),
(N'DEV-009', N'Laptop', N'Lenovo T14', '2024-05-01', N'Assigned', 5),
(N'DEV-010', N'Laptop', N'Acer Aspire 5', '2024-03-22', N'In Stock', NULL);

-- SoftwareLicenses (10)
INSERT INTO dbo.SoftwareLicenses (SoftwareName, Vendor, LicenseKey, PurchaseDate, ExpirationDate, AssignedTo) VALUES
(N'Microsoft 365', N'Microsoft', N'KEY-0001', '2024-01-01', '2026-01-01', 1),
(N'Windows 11 Pro', N'Microsoft', N'KEY-0002', '2023-12-01', '2028-12-01', 4),
(N'Power BI Pro', N'Microsoft', N'KEY-0003', '2024-05-01', '2025-05-01', 5),
(N'Adobe Photoshop', N'Adobe', N'KEY-0004', '2024-02-10', '2025-02-10', 11),
(N'FortiClient VPN', N'Fortinet', N'KEY-0005', '2024-04-05', '2026-04-05', 2),
(N'Visual Studio', N'Microsoft', N'KEY-0006', '2023-10-20', '2026-10-20', 4),
(N'AutoCAD LT', N'Autodesk', N'KEY-0007', '2023-08-15', '2024-08-15', NULL),
(N'SQL Server Std', N'Microsoft', N'KEY-0008', '2024-01-10', '2026-01-10', 1),
(N'MS Project', N'Microsoft', N'KEY-0009', '2023-09-09', '2025-09-09', 6),
(N'Jira Software', N'Atlassian', N'KEY-0010', '2024-06-06', '2025-06-06', 6);

-- Tickets (10)
INSERT INTO dbo.Tickets (EmployeeID, ProjectID, IssueType, Description, Status) VALUES
(6, 4, N'Access', N'Cannot access help desk portal', N'Open'),
(2, 1, N'Network', N'Switch configuration error', N'In Progress'),
(1, NULL, N'Hardware', N'Laptop overheating', N'Open'),
(4, 6, N'Deployment', N'CI pipeline fails', N'Open'),
(5, 3, N'Data', N'ETL job failure overnight', N'Open'),
(11, 9, N'Frontend', N'Build tool version mismatch', N'Open'),
(3, 5, N'Security', N'Endpoint not reporting', N'Resolved'),
(2, 1, N'Network', N'VPN unstable after hours', N'Open'),
(10, 7, N'IoT', N'Sensor offline in Zone B', N'Open'),
(8, NULL, N'Finance App', N'Cannot export to Excel', N'Open');
GO
*/

--================================================================================================================================================
/*
GO
CREATE VIEW dbo.ActiveProjectsView AS
SELECT ProjectID, ProjectName, StartDate, EndDate, Budget, Status
FROM dbo.Projects
WHERE Status = 'Active';
GO
SELECT * FROM ActiveProjectsView

GO
CREATE VIEW dbo.DeviceAssignmentView AS
SELECT d.DeviceID, d.DeviceTag, d.DeviceType, d.BrandModel, d.Status,
       e.EmployeeID, e.FirstName, e.LastName, e.Email
FROM dbo.Devices d
LEFT JOIN dbo.Employees e ON d.AssignedTo = e.EmployeeID;
GO

select * from DeviceAssignmentView

GO
CREATE VIEW dbo.LicenseExpiryView AS
SELECT LicenseID, SoftwareName, Vendor, LicenseKey, ExpirationDate,
       DATEDIFF(DAY, SYSDATETIME(), ExpirationDate) AS DaysToExpire,
       AssignedTo
FROM dbo.SoftwareLicenses
WHERE ExpirationDate <= DATEADD(DAY, 30, CAST(SYSDATETIME() AS DATE));
GO
SELECT * FROM LicenseExpiryView
*/


--=====================================================================================================================================
--STORE PROCEDURE
/*
GO
CREATE PROCEDURE dbo.AssignDeviceToEmployee
    @DeviceID INT,
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        -- Ensure device exists and is not retired
        IF NOT EXISTS (SELECT 1 FROM dbo.Devices WHERE DeviceID = @DeviceID AND Status <> 'Retired')
            THROW 50001, 'Device not found or retired.', 1;

        -- Ensure employee exists
        IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE EmployeeID = @EmployeeID)
            THROW 50002, 'Employee not found.', 1;

        UPDATE dbo.Devices
        SET AssignedTo = @EmployeeID,
            Status = 'Assigned'
        WHERE DeviceID = @DeviceID;

        COMMIT TRAN;
        SELECT 'Success' AS Result, @DeviceID AS DeviceID, @EmployeeID AS EmployeeID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrNum INT = ERROR_NUMBER();
        RAISERROR('AssignDeviceToEmployee failed (%d): %s', 16, 1, @ErrNum, @ErrMsg);
    END CATCH
END;
GO
EXEC dbo.AssignDeviceToEmployee @DeviceID = 2  , @EmployeeID=9;
select * from Devices where DeviceID=2;

SELECT * FROM Devices;

GO
CREATE PROCEDURE dbo.AddNewTicket
    @EmployeeID INT,
    @ProjectID INT = NULL,
    @IssueType NVARCHAR(80),
    @Description NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE EmployeeID = @EmployeeID)
            THROW 50003, 'Employee not found.', 1;

        INSERT INTO dbo.Tickets (EmployeeID, ProjectID, IssueType, Description, Status)
        VALUES (@EmployeeID, @ProjectID, @IssueType, @Description, N'Open');

        COMMIT TRAN;
        SELECT SCOPE_IDENTITY() AS NewTicketID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrNum INT = ERROR_NUMBER();
        RAISERROR('AddNewTicket failed (%d): %s', 16, 1, @ErrNum, @ErrMsg);
    END CATCH
END;

EXEC dbo.AddNewTicket  @EmployeeID=1,@ProjectID=1, @IssueType='Heng',@Description='jkaj;dsfklja;ksjd;f';

SELECT * FROM Tickets;
*/

/*
GO
CREATE PROCEDURE dbo.UpdateProjectStatus
    @ProjectID INT,
    @NewStatus NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @NewStatus NOT IN (N'Planned', N'Active', N'On Hold', N'Completed', N'Cancelled')
            THROW 50004, 'Invalid project status.', 1;

        UPDATE dbo.Projects SET Status = @NewStatus WHERE ProjectID = @ProjectID;
        SELECT ProjectID, ProjectName, Status FROM dbo.Projects WHERE ProjectID = @ProjectID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrNum INT = ERROR_NUMBER();
        RAISERROR('UpdateProjectStatus failed (%d): %s', 16, 1, @ErrNum, @ErrMsg);
    END CATCH
END;
GO

EXEC  dbo.UpdateProjectStatus @ProjectID=1,@NewStatus='Completed';
SELECT * FROM Projects;
*/


--=======================================================================================================================================================================================
--TRIGGER

/*
CREATE TABLE TicketHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NOT NULL,
    OldStatus NVARCHAR(20) NOT NULL,
    NewStatus NVARCHAR(20) NOT NULL,
    ChangeDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    ChangedBy NVARCHAR(100) NULL
);
GO
CREATE TRIGGER dbo.trg_TicketStatusChange
ON dbo.Tickets
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO TicketHistory (TicketID, OldStatus, NewStatus, ChangedBy)
    SELECT
        i.TicketID,
        d.Status AS OldStatus,
        i.Status AS NewStatus,
        SUSER_SNAME()  -- SQL Server login name that made the change
    FROM inserted i
    JOIN deleted d ON i.TicketID = d.TicketID
    WHERE i.Status <> d.Status;  -- only log if status actually changed
END;

UPDATE Tickets
SET Status = 'In Progress'
WHERE TicketID = 1;

SELECT * FROM TicketHistory;
*/

--==============================================================================================================================================================================================================
--======================================================================
-- USER ROLE AND PERMISSION
--======================================================================

/*
USE master;
GO
CREATE LOGIN it_admin WITH PASSWORD = 'StrongPasswordA123', CHECK_POLICY = ON;
CREATE LOGIN it_support WITH PASSWORD = 'StrongPasswordB123', CHECK_POLICY = ON;
CREATE LOGIN viewer WITH PASSWORD = 'StrongPasswordC123', CHECK_POLICY = ON;
GO

USE IT_Management;
GO
CREATE USER IT_Admin FOR LOGIN it_admin;
CREATE USER IT_Support FOR LOGIN it_support;
CREATE USER Viewer FOR LOGIN viewer;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'IT_Admin')
    CREATE ROLE IT_Admin AUTHORIZATION dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'IT_Support')
    CREATE ROLE IT_Support AUTHORIZATION dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Viewer')
    CREATE ROLE Viewer AUTHORIZATION dbo;

ALTER ROLE db_owner ADD MEMBER IT_Admin;

-- IT_Admin: Full control on dbo schema
GRANT CONTROL ON SCHEMA::dbo TO IT_Admin;

-- IT_Support: Read/Write on tickets, devices, licenses, but no delete
GRANT SELECT, INSERT, UPDATE ON dbo.Tickets TO IT_Support;
GRANT SELECT, INSERT, UPDATE ON dbo.Devices TO IT_Support;
GRANT SELECT, UPDATE ON dbo.SoftwareLicenses TO IT_Support;
DENY DELETE ON dbo.Tickets TO IT_Support;
DENY DELETE ON dbo.Devices TO IT_Support;
DENY DELETE ON dbo.SoftwareLicenses TO IT_Support;

-- Viewer: Read-only on everything in dbo
GRANT SELECT ON SCHEMA::dbo TO Viewer;
GO
*/

--==========================================================================================================================================================================================
--DATABASE BACKUP AND RECOVERY
/*
USE master;
--backup
BACKUP DATABASE IT_Management
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\IT_Management.bak'

--Recovery
RESTORE DATABASE IT_Management
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\IT_Management.bak'
WITH
MOVE 'IT_Management' TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\IT_Management.mdf',
MOVE 'IT_Management_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\IT_Management.ldf',
STATS = 10;
*/

/*
SELECT * FROM Departments
SELECT * FROM Employees
SELECT * FROM Projects
SELECT * FROM ProjectAssignments
SELECT * FROM Devices
SELECT * FROM SoftwareLicenses
SELECT * FROM Tickets
*/




