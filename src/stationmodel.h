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
        InterchangeRole
    };

    StationModel(QObject *parent = 0);
    void getdata();
    void addstation(const Station &station);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE QVariant singledata(const int &row, int role = Qt::DisplayRole) const;
    Q_INVOKABLE void search(int source, int destination);
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<Station> stationlist;
    QList<Station> routestationlist;
    Graphm systemmap;
};

#endif // STATIONMODEL_H
