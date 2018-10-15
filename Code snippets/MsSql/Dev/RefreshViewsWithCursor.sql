CREATE PROCEDURE [dbo].[RefreshViews]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ViewName VARCHAR(255);

    DECLARE view_cursor CURSOR FAST_FORWARD
    FOR
	   --- Get all the user defined views with no schema binding on them
	   SELECT DISTINCT
        ss.name + '.' + av.name AS ViewName
    FROM sys.all_views av
        JOIN sys.schemas ss ON av.schema_id = ss.schema_id
    WHERE   OBJECTPROPERTY(av.[object_id], 'IsSchemaBound') <> 1
        AND av.Is_Ms_Shipped = 0

    OPEN view_cursor

    FETCH NEXT FROM view_cursor 
    INTO @ViewName

    WHILE @@FETCH_STATUS = 0 
	   BEGIN
        EXEC sp_refreshview @ViewName;
        FETCH NEXT FROM view_cursor INTO @ViewName;
    END
    CLOSE view_cursor
    DEALLOCATE view_cursor

    SET NOCOUNT OFF;
END
GO
