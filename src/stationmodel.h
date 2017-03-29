#ifndef STATIONMODEL_H
#define STATIONMODEL_H
#include <QAbstractListModel>
#include <QSqlDatabase>
#include <QSqlQuery>
#include "station.h"


class StationModel : public QAbstractListModel
{
    Q_OBJECT
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
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<Station> stationlist;
};

#endif // STATIONMODEL_H
