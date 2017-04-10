#ifndef STATION_H
#define STATION_H
#include <QString>


class Station
{
private:
    int num, count, same[3], line_id;
    QString stn_num, stn_name, line_name;
    bool interchange;
    QString /*_action, */_direction;
    int _action;
public:
    Station();
    Station(int n,int c,int s1,int s2,int s3,QString snum,QString sname,int lid,QString lname,bool i);
    void setactiondirection(int a,QString d);
    int number() const;
    QString stationnumber() const;
    QString stationname() const;
    bool isinterchange() const;
    int linescount() const;
    QString linename() const;
    int lineid() const;
    int samestations(int i) const;
    int action() const;
    QString direction() const;
};

#endif // STATION_H
