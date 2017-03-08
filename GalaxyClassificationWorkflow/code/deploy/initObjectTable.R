initObjectTable <- function(modelTable, keyName="id", valueName="value", versionName="version",
                            connectionString=NULL)
{
    dest <- RxOdbcData(sqlQuery="select 1", connectionString=connectionString)
    rxOpen(dest, mode="r")
    rxExecuteSQLDDL(dest, sprintf("drop table if exists %s", modelTable))

    qry <- if(!is.null(versionName))
        sprintf("create table %s ([%s] nvarchar(50), [%s] nvarchar(50), [%s] varbinary(max))",
            modelTable, keyName, versionName, valueName)
    else sprintf("create table %s ([%s] nvarchar(50), [%s] varbinary(max))",
            modelTable, keyName, valueName)

    rxExecuteSQLDDL(dest, qry)
    rxClose(dest)
}
