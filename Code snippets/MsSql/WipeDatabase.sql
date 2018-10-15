DECLARE delCursor CURSOR FOR
WITH a AS
(
   SELECT 0 AS lvl, 
          t.object_id AS tblID 
     FROM sys.TABLES t
    WHERE t.is_ms_shipped=0
      AND t.object_id NOT IN (SELECT f.referenced_object_id FROM sys.foreign_keys f)
   UNION ALL
   SELECT a.lvl + 1 AS lvl, 
          f.referenced_object_id AS tblId
     FROM a
    INNER JOIN sys.foreign_keys f 
       ON a.tblId=f.parent_object_id 
      AND a.tblID<>f.referenced_object_id
)
SELECT 'DELETE FROM ['+ object_schema_name(tblID) + '].[' + object_name(tblId) + ']' 
  FROM a
 GROUP BY tblId 
ORDER BY MAX(lvl),1

DECLARE @delScript NVARCHAR(MAX)

PRINT 'Full db wipe started'

OPEN delCursor
FETCH NEXT FROM delCursor INTO @delScript
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Executing ' + @delScript
	EXECUTE ( @delScript )
	FETCH NEXT FROM delCursor INTO @delScript
END

PRINT 'Full db wipe completed'

DEALLOCATE delCursor