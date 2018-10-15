SELECT tables.NAME    TableName,
    col.NAME       ColumnName,
    types.NAME     Type,
    value          Comment
FROM sys.tables tables
    INNER JOIN sys.objects obj
    ON tables.object_id = obj.object_id
        AND obj.type = N'U'
    INNER JOIN sys.columns col
    ON tables.object_id = col.object_id
    INNER JOIN sys.types types
    ON col.user_type_id = types.user_type_id
    LEFT JOIN sys.extended_properties prop
    ON tables.object_id = prop.major_id
        AND prop.major_id = col.object_id
        AND prop.minor_id = col.column_id