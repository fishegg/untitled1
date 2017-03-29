#include "databaseconnector.h"
//#include <QSqlDatabase>
//#include <QSqlQuery>
#include <qdebug.h>
//#include <QStringList>

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

