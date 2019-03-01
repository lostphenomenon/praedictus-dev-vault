-- This snippet retrieves (extracts) package names from
-- sql server agent jobs cmd value 

SELECT JS.command, REVERSE(SUBSTRING(REVERSE(SUBSTRING(JS.command, 1, PATINDEX('%.dtsx%', JS.command)+4)),1, CHARINDEX('\', REVERSE(SUBSTRING(JS.command, 0, PATINDEX('%.dtsx%', JS.command)+4)))))
FROM msdb.dbo.sysjobsteps JS
     INNER JOIN msdb.dbo.sysjobs J
     ON JS.job_id = J.job_id
WHERE JS.subsystem = 'SSIS'
