-- =============================================
-- Author:			Kristóf Tóth
-- Creation date:	20/03/2018
-- Description:		Used to allow users not of sysadmin to run master.dbo.xp_sqlagent_enum_jobs
-- =============================================

CREATE PROCEDURE [dbo].[usp_getRunningSqlJobs]
WITH
     EXECUTE AS 'dbo'
AS
BEGIN
     EXEC master.dbo.xp_sqlagent_enum_jobs 1,'dbo'
END
