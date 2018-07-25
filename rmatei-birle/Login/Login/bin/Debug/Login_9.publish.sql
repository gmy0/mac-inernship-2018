﻿/*
Deployment script for LoginExample

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "LoginExample"
:setvar DefaultFilePrefix "LoginExample"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Altering [dbo].[Login]...';


GO
ALTER PROCEDURE [dbo].[Login]
	@Email nvarchar(50),
	@Password nvarchar(30),
	@Response nvarchar(20) OUT
AS
	DECLARE
	@RetrievedDisplayName nvarchar(20),
	@RetrievedPass nvarchar(64),
	@RetrievedID int = -1,
	@HashedPass nchar(64)

	SELECT @RetrievedPass = Password, @RetrievedID = ID, @RetrievedDisplayName = DisplayName FROM [User]
	WHERE Email = @Email

	IF (@RetrievedID = -1) 
	BEGIN
		INSERT INTO [Log] (UserID, Message) VALUES (null, 'Login unsuccessful. Email ' + @Email + ' not found')
		SET @Response = 'ERROR'
		RETURN -1
	END
	
	SELECT @HashedPass = HASHBYTES('SHA2_256', @Password)

	IF(@HashedPass = @RetrievedPass)
	BEGIN
		INSERT INTO [Log] (UserID, Message) VALUES (@RetrievedID, 'Login successful. Email ' + @Email + ' and password were correct')
		SET @Response = @RetrievedDisplayName
		RETURN 1
	END

	ELSE 
	BEGIN
		INSERT INTO [Log] (UserID, Message) VALUES (@RetrievedID, 'Login unsuccessful. Email ' + @Email + ' found, but password was incorrect')
		SET @Response = 'ERROR'
		RETURN 0
	END
GO
PRINT N'Update complete.';


GO
