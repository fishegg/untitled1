#ifndef DATABASECONNECTOR_H
#define DATABASECONNECTOR_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QObject>


class DatabaseConnector : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseConnector(QObject *parent = 0);
    bool openconnection();

signals:

public slots:
};

#endif // DATABASECONNECTOR_H
