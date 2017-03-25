#include "databaseconnector.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <qdebug.h>
#include <QStringList>

DatabaseConnector::DatabaseConnector(QObject *parent)
{
    openconnection();
    getdata();
}

bool DatabaseConnector::openconnection()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("/home/nemo/testdata/test.sqlite");
    if(db.open())
    {
        qDebug() << "connection opened" << endl;
        return true;
    }
    else
    {
        qDebug() << "connection open failed" << endl;
        return false;
    }
}

void DatabaseConnector::getdata()
{
    QSqlQuery query("SELECT station_name FROM test");
    while(query.next())
    {
        names_list << query.value("station_name").toString();
        qDebug() << query.value("station_name").toString();
    }
}

QStringList DatabaseConnector::getlist()
{
    return names_list;
}

