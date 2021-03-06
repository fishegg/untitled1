#ifndef DATABASECONNECTOR_H
#define DATABASECONNECTOR_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QObject>
#include <QStringList>


class DatabaseConnector : public QObject
{
    Q_OBJECT
private:
    QStringList names_list;
public:
    explicit DatabaseConnector(QObject *parent = 0);
    bool openconnection();
    void getdata();
    Q_INVOKABLE QStringList getlist();
    Q_INVOKABLE int getlistsize();
    Q_INVOKABLE QString getlistelement(int i);

signals:

public slots:
};

#endif // DATABASECONNECTOR_H
