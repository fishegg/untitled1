#include "station.h"

Station::Station()
{
    num = -1;
    count = 0;
    stn_name = "null";
    stn_num = "null";
    interchange = false;
    line_name = "null";
    line_id = 0;
    same[0] = -1;
    same[1] = -1;
    same[2] = -1;
    _action = -1;
    _direction = "";
}

Station::Station(int n,int c,int s1,int s2,int s3,QString snum,QString sname,int lid,QString lname,bool i)
{
    num = n;
    count = c;
    stn_name = sname;
    stn_num = snum;
    interchange = i;
    line_name = lname;
    line_id = lid;
    same[0] = s1;
    same[1] = s2;
    same[2] = s3;
}

void Station::setactiondirection(int a, QString d)
{
    _action = a;
    _direction = d;
}

int Station::number() const
{
    return num;
}

QString Station::stationnumber() const
{
    return stn_num;
}

QString Station::stationname() const
{
    return stn_name;
}

bool Station::isinterchange() const
{
    return interchange;
}

int Station::linescount() const
{
    return count;
}

QString Station::linename() const
{
    return line_name;
}

int Station::lineid() const
{
    return line_id;
}

int Station::samestations(int i) const
{
    return same[i-1];
}

int Station::action() const
{
    return _action;
}

QString Station::direction() const
{
    return _direction;
}
