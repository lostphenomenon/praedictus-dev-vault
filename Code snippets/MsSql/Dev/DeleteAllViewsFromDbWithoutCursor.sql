DECLARE @sql VARCHAR(MAX) = ''
        , @crlf VARCHAR(2) = CHAR(13) + CHAR(10)
;
SELECT @sql = @sql + 'DROP VIEW ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(v.name) +';' + @crlf
FROM sys.views v
PRINT @sql;
EXEC(@sql);

-- Further info:
-- https://stackoverflow.com/questions/11689557/delete-all-views-from-sql-server