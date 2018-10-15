SELECT execquery.last_execution_time AS [Date Time]
	, execsql.TEXT AS [Script]
FROM sys.dm_exec_query_stats AS execquery
CROSS APPLY sys.dm_exec_sql_text(execquery.sql_handle) AS execsql
where execsql.TEXT like '%anything you remember from query text%'
ORDER BY execquery.last_execution_time DESC

-- Further info:
-- https://tomssl.com/2015/10/16/recover-unsaved-sql-queries-from-sql-server-management-studio-ssms/