#include "station.h"

Station::Station()
{
    num = -1;
    count = 0;
    stn_name = "null";
    stn_num = "null";
    interchange = false;
    line = "null";
    same[0] = -1;
    same[1] = -1;
    same[2] = -1;
}

Station::Station(int n,int c,int s1,int s2,int s3,QString snum,QString sname,QString l,bool i)
{
    num = n;
    count = c;
    stn_name = sname;
    stn_num = snum;
    interchange = i;
    line = l;
    same[0] = s1;
    same[1] = s2;
    same[2] = s3;
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
    return line;
}

int Station::samestaitions(int i) const
{
    return same[i-1];
}
