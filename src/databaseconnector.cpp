#include "databaseconnector.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <qdebug.h>

DatabaseConnector::DatabaseConnector(QObject *parent)
{
    openconnection();
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

