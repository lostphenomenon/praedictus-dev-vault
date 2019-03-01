-- The following script fetches job execution history and 
-- errors from two possible source
-- either from SSISDB or if there is no present error there
-- from jobhistory
-- may need to adjust the step ID to your conventions

DROP TABLE IF EXISTS #sql_jobs

CREATE TABLE #sql_jobs
(
     job_id UNIQUEIDENTIFIER NOT NULL,
     last_run_date INT NOT NULL,
     last_run_time INT NOT NULL,
     next_run_date INT NOT NULL,
     next_run_time INT NOT NULL,
     next_run_schedule_id INT NOT NULL,
     requested_to_run INT NOT NULL,
     -- BOOL
     request_source INT NOT NULL,
     request_source_id varchar(128) NULL,
     running INT NOT NULL,
     -- BOOL
     current_step INT NOT NULL,
     current_retry_attempt INT NOT NULL,
     job_state INT NOT NULL
)

insert into #sql_jobs
exec [dbo].[usp_getRunningSqlJobs]

-- Create connector table which contains job id-s with their corresponding package names extracted from given sources
drop table if EXISTS #sqlagent_job_ssis_packages
SELECT
     J.job_id
	, REVERSE(SUBSTRING(REVERSE(SUBSTRING(JS.command, 1, PATINDEX('%.dtsx%', JS.command)+4)),1, CHARINDEX('\', REVERSE(SUBSTRING(JS.command, 0, PATINDEX('%.dtsx%', JS.command)+4))))) AS PackageName
into #sqlagent_job_ssis_packages
FROM msdb.dbo.sysjobsteps JS
     INNER JOIN msdb.dbo.sysjobs J
     ON JS.job_id = J.job_id
WHERE JS.subsystem = 'SSIS'

SELECT distinct
     SERVERPROPERTY('MachineName') AS InstanceName
	, JOBS.name [Name]
	, JOBS.job_id AS [JobId]
	, JACTIVITY.start_execution_date [StartedDate]
	, CASE #sql_jobs.running
	 WHEN 1	THEN DATEDIFF(second, JACTIVITY.start_execution_date, GETDATE())
	 ELSE DATEDIFF(second, JACTIVITY.start_execution_date, JACTIVITY.stop_execution_date)
	 END AS [Duration]
	, CASE #sql_jobs.running
	 WHEN 1 THEN 'IN PROGRESS'
	 WHEN 0 THEN CASE JHISTORY.RUN_STATUS
					WHEN 0 THEN 'FAILED'
					WHEN 1 THEN 'SUCCEEDED'
					WHEN 2 THEN 'RETRY'
					WHEN 3 THEN 'CANCELED'
				 END
	 END AS [Status]
	 , CASE JOBS.[enabled]
       WHEN 1 THEN 'true'
       WHEN 0 THEN 'false'
     END AS [IsEnabled]
	 , CASE
		WHEN JSCHEDULES.schedule_id IS NULL THEN NULL
		WHEN JSCHEDULES.schedule_id IS NOT NULL THEN try_convert(datetime,(stuff(stuff(convert(char(10),JSCHEDULES.next_run_date),5,0,'-'),8,0,'-') + ' ' + stuff(stuff(right('00000' + convert (varchar(6),JSCHEDULES.next_run_time),6),3,0,':'),6,0,':')))
	  END AS [Schedule],
     CASE
		WHEN JHISTORY.run_status = 0 AND ssisHistory.ErrorMessage is not null THEN ssisHistory.ErrorMessage
		WHEN JHISTORY.run_status = 0 THEN jLastError.ErrorMessage
	  END AS ErrorMessage,
     CASE #sql_jobs.running
	 WHEN 1 THEN 1
	 WHEN 0 THEN CASE JHISTORY.RUN_STATUS
					WHEN 0 THEN -1
					WHEN 1 THEN 2
					WHEN 2 THEN 0
					WHEN 3 THEN 1
				 END
	 END AS [SortNo]
FROM [msdb].dbo.sysjobs JOBS
     LEFT JOIN (
	SELECT
          ROW_NUMBER() OVER(PARTITION BY SA.job_id ORDER BY SA.start_execution_date desc) AS rn,
          *
     from msdb.dbo.sysjobactivity SA
) JACTIVITY ON JACTIVITY.job_id = JOBS.job_id AND JACTIVITY.rn = 1
     LEFT JOIN #sql_jobs ON #sql_jobs.job_id = JOBS.job_id
     LEFT JOIN
     (
	select
          ROW_NUMBER() OVER(PARTITION BY sjh.job_id ORDER BY sjh.run_date desc, sjh.run_time desc) AS rn,
          sjh.instance_id,
          sjh.job_id,
          sjh.run_date,
          sjh.run_time,
          sjh.step_id,
          RUN_STATUS,
          sjh.message as ErrorMessage
     from (select *
          from [msdb].[dbo].[sysjobhistory]
          where step_id = 0) sjh		
          -- ADJUST STEP ID
) JHISTORY ON JHISTORY.job_id = JOBS.job_id and JHISTORY.rn = 1
     LEFT JOIN
     (
select
          ROW_NUMBER() OVER(PARTITION BY sjh.job_id ORDER BY sjh.run_date desc, sjh.run_time desc) AS rn,
          sjh.instance_id,
          sjh.job_id,
          sjh.run_date,
          sjh.run_time,
          sjh.step_id,
          RUN_STATUS,
          sjh.message as ErrorMessage
     from (select *
          from [msdb].[dbo].[sysjobhistory]
          where step_id = 1 and run_status = 0) sjh
) jLastError on JOBS.job_id = jLastError.job_id
     LEFT JOIN msdb.dbo.sysjobschedules JSCHEDULES ON JSCHEDULES.job_id = JOBS.job_id
     LEFT JOIN #sqlagent_job_ssis_packages sHistory on sHistory.job_id = JOBS.job_id
     LEFT JOIN (
	select sp.job_id, sp.PackageName, STRING_AGG(em.message,' ') AS ErrorMessage
     from #sqlagent_job_ssis_packages sp
          left join (SELECT MAX(execution_id) as execution_id, package_name
          FROM SSISDB.catalog.executions
          group by package_name) spp on spp.package_name = sp.PackageName
          left join SSISDB.catalog.event_messages em on em.operation_id = spp.execution_id
               AND em.event_name NOT LIKE '%Validate%' and em.event_name = 'OnError'
     group by sp.job_id, sp.PackageName
) ssisHistory on ssisHistory.job_id = JOBS.job_id
WHERE
CASE #sql_jobs.running
	 WHEN 1 THEN 'IN PROGRESS'
	 WHEN 0 THEN CASE JHISTORY.RUN_STATUS
					WHEN 0 THEN 'FAILED'
					WHEN 1 THEN 'SUCCEEDED'
					WHEN 2 THEN 'RETRY'
					WHEN 3 THEN 'CANCELED'
				 END
	 END is not null
ORDER BY CASE #sql_jobs.running
	 WHEN 1 THEN 'IN PROGRESS'
	 WHEN 0 THEN CASE JHISTORY.RUN_STATUS
					WHEN 0 THEN 'FAILED'
					WHEN 1 THEN 'SUCCEEDED'
					WHEN 2 THEN 'RETRY'
					WHEN 3 THEN 'CANCELED'
				 END
	 END