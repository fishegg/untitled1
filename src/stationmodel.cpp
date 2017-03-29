#include <qdebug.h>
#include "stationmodel.h"
#include "station.h"

StationModel::StationModel(QObject *parent) : QAbstractListModel(parent)
{
    getdata();
}

void StationModel::getdata()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("/home/nemo/testdata/test.sqlite");
    if(db.open())
    {
        qDebug() << "connection opened" << endl;
        int number, lines_count, same_station[3];
        QString station_name, station_number, line_name;
        bool interchange;
        QSqlQuery query("SELECT * FROM test");
        while(query.next())
        {
            station_number = query.value("station_no_").toString();
            number = query.value("no_").toInt();
            station_name = query.value("station_name").toString();
            interchange = query.value("interchange").toBool();
            lines_count = query.value("lines_count").toInt();
            line_name = query.value("line_name").toString();
            same_station[0] = query.value("same_no_1").toInt();
            same_station[1] = query.value("same_no_2").toInt();
            same_station[2] = query.value("same_no_3").toInt();
            if(station_name != "无")
            {
                Station station(number,lines_count,same_station[0],same_station[1],same_station[2],station_number,station_name,line_name,interchange);
                addstation(station);
            }
            qDebug() << query.value("station_no_").toString() + query.value("station_name").toString();
        }
    }
    else
    {
        qDebug() << "connection open failed" << endl;
    }
    db.close();
}

void StationModel::addstation(const Station &station)
{
    beginInsertRows(QModelIndex(),rowCount(),rowCount());
    stationlist << station;
    endInsertRows();
}

int StationModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return stationlist.count();
}

QVariant StationModel::data(const QModelIndex &index, int role) const
{
    //qDebug() << "index.row" << index.row() << endl;
    if(index.row() < 0 || index.row() > stationlist.count())
    {
        return QVariant();
    }
    //qDebug() << "data() role" << role << endl;
    //qDebug() << "data() index.row() = " << index.row() << " index.column() = " << index.column() << endl;

    const Station &station = stationlist[index.row()];
    if(role == NumRole)
    {
        return station.number();
    }
    else if(role == CountRole)
    {
        return station.linescount();
    }
    else if(role == Same1Role)
    {
        return station.samestaitions(1);
    }
    else if(role == Same2Role)
    {
        return station.samestaitions(2);
    }
    else if(role == Same3Role)
    {
        return station.samestaitions(3);
    }
    else if(role == StnNumRole)
    {
        return station.stationnumber();
    }
    else if(role == StnNameRole)
    {
        return station.stationname();
    }
    else if(role == LineRole)
    {
        return station.linename();
    }
    else if(role == InterchangeRole)
    {
        return station.isinterchange();
    }

    return QVariant();
}

QVariant StationModel::singledata(const int &row, int role) const
{
    if(row < 0 || row > stationlist.count())
    {
        //qDebug() << "sigledata get failed" << endl;
        return QVariant();
    }
    QModelIndex index = createIndex(row,0);
    //qDebug() << "singledata() role" << role << endl;
    //qDebug() << "singledata() index.row() = " << index.row() << " index.column() = " << index.column() << endl;
    //QVariant d = data(index,role);
    //qDebug() << "single data d = " << d.toString() << endl;
    //return d;
    return data(index,role);
}

QHash<int, QByteArray> StationModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NumRole] = "number";
    roles[CountRole] = "lines_count";
    roles[Same1Role] = "same_station_1";
    roles[Same2Role] = "same_station_2";
    roles[Same3Role] = "same_station_3";
    roles[StnNumRole] = "station_number";
    roles[StnNameRole] = "station_name";
    roles[LineRole] = "line_name";
    roles[InterchangeRole] = "is_interchange";
    return roles;
}

void StationModel::search(int source, int destination)
{
    RouteSearch routesearch
}
