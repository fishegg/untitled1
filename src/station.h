#ifndef STATION_H
#define STATION_H
#include <QString>


class Station
{
private:
    int num, count, same[3];
    QString stn_num, stn_name, line;
    bool interchange;
public:
    Station();
    Station(int n,int c,int s1,int s2,int s3,QString snum,QString sname,QString l,bool i);
    int number() const;
    QString stationnumber() const;
    QString stationname() const;
    bool isinterchange() const;
    int linescount() const;
    QString linename() const;
    int samestaitions(int i) const;
};

#endif // STATION_H
