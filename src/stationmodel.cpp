#include <qdebug.h>
#include "stationmodel.h"
#include "station.h"

StationModel::StationModel(QObject *parent) : QAbstractListModel(parent)
{
    //getdata();
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("/home/nemo/testdata/test.sqlite");
    if(db.open())
    {
        qDebug() << "connection opened" << endl;
        QSqlQuery query("SELECT * FROM information");
        query.next();
        station_count = query.value("station_count").toInt();
        qDebug() << "station count" << station_count;
        station_index = new int[station_count];
        for(int i;i<station_count;i++)
            station_index[i]=-1;
    }
}

StationModel::~StationModel()
{
    db.close();
    delete [] station_index;
    station_index = nullptr;
}

int StationModel::getfulllistdata()
{
    //int i;//, j;
    if(db.open())
    {
        qDebug() << "connection opened" << endl;
        int number = 0, lines_count, same_station[3];
        QString station_name, station_number, line_name;
        //QString serial_distance;
        bool interchange, in_use;

        beginResetModel();
        stationlist.clear();
        endResetModel();

        QSqlQuery query("SELECT * FROM test");
        while(query.next())
        {
            in_use = query.value("in_use").toBool();
            if(in_use != false)
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
                Station station(number,lines_count,same_station[0],same_station[1],same_station[2],station_number,station_name,line_name,interchange);
                addstation(station);
                station_index[number] = stationlist.size() - 1;
            }
            /**/
            //Station station(number,lines_count,same_station[0],same_station[1],same_station[2],station_number,station_name,line_name,interchange);
            //addstation(station);
            //qDebug() << query.value("station_no_").toString() + query.value("station_name").toString();
        }
        //station_count = number + 1;
        if(station_count != number + 1)
        {
            return Error;
        }

        /*query.clear();
        systemmap.Init(station_count);
        query.exec("SELECT weight FROM testgraph");
        query.first();
        i = 0;
        do
        {
            int cost;//, row = i*station_count;
            int row = i / station_count, column = i % station_count;
            //serial_distance = query.value("weight").toString();//.toUtf8().data();
            cost = query.value("weight").toInt();
            //qDebug() << "station count" << station_count;
            //qDebug() << serial_distance << endl;
            /*for(j=0; j<station_count; j++)
            {
                cost = serial_distance.section(' ',j,j).toInt();
                systemmap.setedge(i,j,cost);
                qDebug() << "i*j" << row+j << systemmap.weight(i,j);
            }*/
            //systemmap.setedge(row,column,cost);
            //qDebug() << i << row << column << systemmap.weight(row,column);
            //i++;
        //}while(query.next());
        //systemmap.qdebugwholegraph();
        qDebug() << "get full list data finished";
    }
    else
    {
        qDebug() << "connection open failed";
        return Error;
    }
    //db.close();
    return Ready;
}

int StationModel::getmapdata()
{
    int i;//, j;
    if(db.open())
    {
        qDebug() << "connection opened";
        qDebug() << "station count" << station_count;

        if(station_count == 0)
        {
            return Error;
        }

        systemmap.Init(station_count);
        QSqlQuery query("SELECT weight FROM testgraph");
        i = 0;
        while(query.next())
        {
            int cost;//, row = i*station_count;
            int row = i / station_count, column = i % station_count;
            //serial_distance = query.value("weight").toString();//.toUtf8().data();
            cost = query.value("weight").toInt();
            //qDebug() << "station count" << station_count;
            //qDebug() << serial_distance << endl;
            /*for(j=0; j<station_count; j++)
            {
                cost = serial_distance.section(' ',j,j).toInt();
                systemmap.setedge(i,j,cost);
                qDebug() << "i*j" << row+j << systemmap.weight(i,j);
            }*/
            systemmap.setedge(row,column,cost);
            //qDebug() << i << row << column << systemmap.weight(row,column);
            i++;
        }
        /*query.exec("SELECT weight FROM testgraph");
        query.first();
        i = 0;
        do
        {
            int cost;//, row = i*station_count;
            int row = i / station_count, column = i % station_count;
            //serial_distance = query.value("weight").toString();//.toUtf8().data();
            cost = query.value("weight").toInt();
            //qDebug() << "station count" << station_count;
            //qDebug() << serial_distance << endl;
            /*for(j=0; j<station_count; j++)
            {
                cost = serial_distance.section(' ',j,j).toInt();
                systemmap.setedge(i,j,cost);
                qDebug() << "i*j" << row+j << systemmap.weight(i,j);
            }*/
            //systemmap.setedge(row,column,cost);
            //qDebug() << i << row << column << systemmap.weight(row,column);
            /*i++;
        }while(query.next());*/
        //systemmap.qdebugwholegraph();
        qDebug() << "get map data finished";
    }
    else
    {
        qDebug() << "connection open failed";
        return Error;
    }
    //db.close();
    return Ready;
}

int StationModel::getroutelistdata()
{
    int i;//, j;
    if(db.open())
    {
        qDebug() << "connection opened" << endl;
        int number = 0, lines_count, same_station[3];
        QString station_name, station_number, line_name;
        bool interchange;
        int number_temp = 0;
        QSqlQuery query;

        beginResetModel();
        stationlist.clear();
        endResetModel();

        while(!routestationlist.isEmpty())
        {
            number_temp = routestationlist.constFirst();
            routestationlist.removeFirst();
            query.prepare("SELECT * FROM test WHERE no_=:number");
            query.bindValue(":number",number_temp);
            query.exec();
            query.first();
            station_number = query.value("station_no_").toString();
            number = query.value("no_").toInt();
            station_name = query.value("station_name").toString();
            interchange = query.value("interchange").toBool();
            lines_count = query.value("lines_count").toInt();
            line_name = query.value("line_name").toString();
            same_station[0] = query.value("same_no_1").toInt();
            same_station[1] = query.value("same_no_2").toInt();
            same_station[2] = query.value("same_no_3").toInt();
            Station station(number,lines_count,same_station[0],same_station[1],same_station[2],station_number,station_name,line_name,interchange);
            addstation(station);
            query.clear();
        }
        qDebug() << "get route list data finished";
    }
    else
    {
        qDebug() << "connection open failed";
        return Error;
    }
    //db.close();
    return Ready;
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
        return station.samestations(1);
    }
    else if(role == Same2Role)
    {
        return station.samestations(2);
    }
    else if(role == Same3Role)
    {
        return station.samestations(3);
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

QVariant StationModel::data(const int &row, int role) const
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

void StationModel::search(int s, int d)
{
    RouteSearch routesearch(station_count);
    routesearch.search(systemmap_ptr,stationlist,station_index,s,d);
    routesearch.getresult(routestationlist_ptr,stationlist);
}

int StationModel::routedata(const int &index) const
{
    return routestationlist.at(index);
}

int StationModel::routestationlistrowcount() const
{
    return routestationlist.count();
}
