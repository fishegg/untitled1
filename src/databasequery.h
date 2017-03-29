#ifndef DATABASEQUERY_H
#define DATABASEQUERY_H

#include <QObject>
#include <QSqlQuery>
#include <QStringList>
#include <QString>
#include <qdebug.h>
#include "databaseconnector.h"

class DatabaseQuery : public QObject
{
    Q_OBJECT
private:
    QStringList names_list;
public:
    explicit DatabaseQuery(QObject *parent = 0);
    void getdata();

signals:

public slots:
};

#endif // DATABASEQUERY_H
