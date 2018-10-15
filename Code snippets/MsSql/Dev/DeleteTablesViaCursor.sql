/*
* Drop every table from a schema.
*/
DECLARE dropCursor CURSOR FOR
SELECT 'DROP TABLE [schemaname].[' + t.name + ']'
FROM sys.TABLES t
    INNER JOIN sys.SCHEMAS s ON s.schema_id = t.schema_id
WHERE s.name = 'schemaname'
DECLARE @dropScript NVARCHAR(MAX)
OPEN dropCursor
FETCH NEXT FROM dropCursor INTO @dropScript
WHILE @@FETCH_STATUS = 0
BEGIN
    EXECUTE ( @dropScript )
    FETCH NEXT FROM dropCursor INTO @dropScript
END
DEALLOCATE dropCursor
