#ifndef STATIONMODEL_H
#define STATIONMODEL_H
#include <QAbstractListModel>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QString>
//#include <QVector>
#include "station.h"
#include "routesearch.h"


class StationModel : public QAbstractListModel
{
    Q_OBJECT
    Q_ENUMS(StationRoles)
    Q_ENUMS(LoadStatus)
    Q_ENUMS(Action)
public:
    enum StationRoles {
        NumRole = Qt::UserRole + 1,
        CountRole,
        Interchange1Role,
        Interchange2Role,
        Interchange3Role,
        UnpaidInterchange1Role,
        UnpaidInterchange2Role,
        UnpaidInterchange3Role,
        StnNumRole,
        StnNameRole,
        LineRole,
        LineColourRole,
        InterchangeRole,
        ActionRole,
        TowardsRole
    };
    enum LoadStatus {
        Null,
        Ready,
        Error
    };
    enum Action {
        OnTrain,
        Depart,
        Arrive,
        GetOff,
        Exit,
        Transfer,
        ExitTransfer
    };

    StationModel(QObject *parent = 0);
    ~StationModel();
    Q_INVOKABLE int getfulllistdata();
    Q_INVOKABLE int getmapdata();
    Q_INVOKABLE int getroutelistdata();
    void addstation(const Station &station);
    void resetmodel();
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE int fulllistrowcount() const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE QVariant data(const int &row, int role = Qt::DisplayRole) const;
    Q_INVOKABLE QVariant fulllistdata(const int &row, int role = Qt::DisplayRole) const;
    Q_INVOKABLE QString line_colour_at(const int &row);
    Q_INVOKABLE void search(int s, int d);
    Q_INVOKABLE int routedata(const int &index) const;
    Q_INVOKABLE int routelistrowcount() const;
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<Station> stationlist;
    QList<Station> fullstationlist;
    //int* station_index;
    //QList<int> station_index;
    QVector<int> station_index;
    QList<int> routestationlist;
    Graphm systemmap;
    int station_count;
    QList<int>* routestationlist_ptr = &routestationlist;
    Graphm* systemmap_ptr = &systemmap;
    QSqlDatabase db;
};

#endif // STATIONMODEL_H
