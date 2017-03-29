#include "databasequery.h"

DatabaseQuery::DatabaseQuery(QObject *parent) : QObject(parent)
{
    DatabaseConnector db;
}

void DatabaseQuery::getdata()
{
    QString full_string;
    QSqlQuery query("SELECT * FROM test");
    while(query.next())
    {
        full_string = query.value("station_name").toString();
        if(full_string != "无")
        {
            full_string = query.value("station_no_").toString() + " " + full_string;
            names_list << full_string;
        }
        qDebug() << query.value("station_no_").toString() + query.value("station_name").toString();
    }
}
