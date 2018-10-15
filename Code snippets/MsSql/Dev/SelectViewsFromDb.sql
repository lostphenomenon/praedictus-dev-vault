SELECT *
FROM dbo.sysobjects
WHERE ID = OBJECT_ID(N'[schemaname].[viewname]')
    AND OBJECTPROPERTY(id, N'IsView') = 1