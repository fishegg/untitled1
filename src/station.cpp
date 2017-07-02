#include "station.h"

Station::Station()
{
    num = -1;
    count = 0;
    stn_name = "null";
    stn_num = "null";
    is_interchange = false;
    line_name = "null";
    line_id = 0;
    interchange[0] = -1;
    interchange[1] = -1;
    interchange[2] = -1;
    unpaid_interchange[0] = -1;
    unpaid_interchange[1] = -1;
    unpaid_interchange[2] = -1;
    _action = -1;
    _towards = "";
    //line_colour.setNamedColor("000000");
    line_colour = "FFFFFF";
}

Station::Station(int n, int c, int i1, int i2, int i3, int ui1, int ui2, int ui3, QString snum, QString sname, int lid, QString lname, QString lcolour, bool i)
{
    num = n;
    count = c;
    stn_name = sname;
    stn_num = snum;
    is_interchange = i;
    line_name = lname;
    line_id = lid;
    interchange[0] = i1;
    interchange[1] = i2;
    interchange[2] = i3;
    unpaid_interchange[0] = ui1;
    unpaid_interchange[1] = ui2;
    unpaid_interchange[2] = ui3;
    _action = -1;
    _towards = "";
    //line_colour.setNamedColor(lcolour);
    line_colour = lcolour;
}

void Station::setactiontowards(int a, QString t)
{
    _action = a;
    _towards = t;
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
    return is_interchange;
}

int Station::linecount() const
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

int Station::interchangeat(int i) const
{
    return interchange[i-1];
}

int Station::unpaidinterchangeat(int i) const
{
    return unpaid_interchange[i-1];
}

int Station::action() const
{
    return _action;
}

QString Station::towards() const
{
    return _towards;
}

QString Station::linecolour() const
{
    return line_colour;
}

QString Station::stationnumberleft() const
{
    return stn_num.left(stn_num.size() - 2);
}
QString Station::stationnumberright() const
{
    return stn_num.right(2);
}
