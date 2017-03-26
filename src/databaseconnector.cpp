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
    QString full_string;
    QSqlQuery query("SELECT station_no_,station_name FROM test");
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

QStringList DatabaseConnector::getlist()
{
    return names_list;
}

int DatabaseConnector::getlistsize()
{
    return names_list.size();
}

QString DatabaseConnector::getlistelement(int i)
{
    return names_list.at(i);
}

