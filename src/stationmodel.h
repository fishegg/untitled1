#ifndef STATIONMODEL_H
#define STATIONMODEL_H
#include <QAbstractListModel>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QString>
#include "station.h"
#include "routesearch.h"


class StationModel : public QAbstractListModel
{
    Q_OBJECT
    Q_ENUMS(StationRoles)
    Q_ENUMS(LoadStatus)
public:
    enum StationRoles {
        NumRole = Qt::UserRole + 1,
        CountRole,
        Same1Role,
        Same2Role,
        Same3Role,
        StnNumRole,
        StnNameRole,
        LineRole,
        InterchangeRole,
        ActionRole,
        DirectionRole
    };
    enum LoadStatus {
        Null,
        Ready,
        Error
    };

    StationModel(QObject *parent = 0);
    ~StationModel();
    Q_INVOKABLE int getfulllistdata();
    Q_INVOKABLE int getmapdata();
    Q_INVOKABLE int getroutelistdata();
    void addstation(const Station &station);
    void resetmodel();
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE QVariant data(const int &row, int role = Qt::DisplayRole) const;
    Q_INVOKABLE void search(int s, int d);
    Q_INVOKABLE int routedata(const int &index) const;
    Q_INVOKABLE int routestationlistrowcount() const;
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<Station> stationlist;
    int* station_index;
    QList<int> routestationlist;
    Graphm systemmap;
    int station_count;
    QList<int>* routestationlist_ptr = &routestationlist;
    Graphm* systemmap_ptr = &systemmap;
    QSqlDatabase db;
};

#endif // STATIONMODEL_H
