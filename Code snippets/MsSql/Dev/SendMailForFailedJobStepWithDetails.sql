use SSISDB

DECLARE @PackageName VARCHAR(30) = 'PackageName.dtsx';

-- Error messages as JSON

DECLARE @ErrorMessages XML
SET @ErrorMessages = (
	SELECT *
FROM (
	SELECT MESSAGE, package_name, event_name, message_source_name
	FROM (
		   SELECT em.*
		FROM SSISDB.catalog.event_messages em
		WHERE   em.operation_id = (SELECT MAX(execution_id)
			FROM SSISDB.catalog.executions
			where package_name = @PackageName)
			AND event_name NOT LIKE '%Validate%'
		   ) q
	WHERE q.event_name = 'OnError'
	) EventMessage
FOR JSON PATH
)

DECLARE @ErrorMessagesAsText nvarchar(max)
set @ErrorMessagesAsText = convert(nvarchar(max), @ErrorMessages);

select @ErrorMessagesAsText
select @ErrorMessages

-- With simple line html line breaks

DECLARE @PackageName VARCHAR(30) = 'PackageName.dtsx';

select '<h1> Package failed: ' + @PackageName + '</h1></br>' + STRING_AGG('<p>' + Message + '</p>', '</br>')
FROM (
		   SELECT em.*
	FROM SSISDB.catalog.event_messages em
	WHERE   em.operation_id = (SELECT MAX(execution_id)
		FROM SSISDB.catalog.executions
		where package_name = @PackageName)
		AND event_name NOT LIKE '%Validate%'
		   ) q
WHERE q.event_name = 'OnError'

DECLARE @PackageName VARCHAR(30) = 'PackageName.dtsx';

select 'Package failed: ' + @PackageName + CHAR(13) + CHAR(10) + 'Reason: ' + CHAR(13) + CHAR(10) + STRING_AGG(Message,CHAR(13) + CHAR(10))
FROM (
		   SELECT em.*
	FROM SSISDB.catalog.event_messages em
	WHERE   em.operation_id = (SELECT MAX(execution_id)
		FROM SSISDB.catalog.executions
		where package_name = @PackageName)
		AND event_name NOT LIKE '%Validate%'
		   ) q
WHERE q.event_name = 'OnError'

-- Convert it to a HTML talbe

DECLARE @PackageName VARCHAR(30) = 'PackageName.dtsx';

select '<h1> Package failed: ' + @PackageName + '</h1></br>' +
	'<table><tr><th>Error messages: </th></tr>' +
	STRING_AGG('<tr><td>' + Message,'</td></tr>') +
	'</table>'
FROM (
		   SELECT em.*
	FROM SSISDB.catalog.event_messages em
	WHERE   em.operation_id = (SELECT MAX(execution_id)
		FROM SSISDB.catalog.executions
		where package_name = @PackageName)
		AND event_name NOT LIKE '%Validate%'
		   ) q
WHERE q.event_name = 'OnError'

-- The mail sending procecure example:

DECLARE @jobname nvarchar(128) = 'Job name'
DECLARE @recipients nvarchar(128) = 'Email recipients'
DECLARE @PackageName VARCHAR(30) = 'Somepackage.dtsx'

DECLARE @CorrelationID uniqueidentifier = NEWID()
DECLARE @EventType nvarchar(128) = 'ERROR'
DECLARE @Input nvarchar(max) = NULL

DECLARE @ErrorMessage nvarchar(max) = NULL
SET @ErrorMessage = (
	select '<h1> Package failed: ' + @PackageName + '</h1></br>' + STRING_AGG('<p>' + Message + '</p>', '</br>')
FROM (
		   SELECT em.*
	FROM SSISDB.catalog.event_messages em
	WHERE   em.operation_id = (SELECT MAX(execution_id)
		FROM SSISDB.catalog.executions
		where package_name = @PackageName)
		AND event_name NOT LIKE '%Validate%'
		   ) q
WHERE q.event_name = 'OnError'
)

DECLARE @subject nvarchar(128) = @jobname + ' has failed for ' + @@SERVERNAME +' CorrelationId: ' + CONVERT(NVARCHAR(50), @CorrelationID)

EXEC msdb.dbo.sp_send_dbmail
	@profile_name = 'ImmaDba',  
	@recipients = @recipients,
	@subject = @subject,
	@body = @ErrorMessage,
	@importance = 'High',  
	@body_format = 'HTML'