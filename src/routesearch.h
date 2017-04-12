#ifndef ROUTESEARCH_H
#define ROUTESEARCH_H
#include <QStack>
#include <QQueue>
#include "station.h"
#include "graphm.h"


class RouteSearch
{
private:
    int *Distance;
    int *Distance_temp;
    int *From;
    int *From_temp;
    int vertex;
    int source, destination;
    QQueue<int> source_list;
    QQueue<int> destination_list;
    int minvertex(Graphm* G, bool use_temp_array)
    {
        int i, v = -1;
        for(i=0; i<G->n(); i++)
        {
            if(G->getmark(i) == 0)
            {
                v = i;
                break;
            }
        }
        if(!use_temp_array)
        {
            for(i++; i<G->n(); i++)
            {
                if((G->getmark(i) == 0) && (Distance[i] < Distance[v]))
                {
                    v = i;
                }
            }
        }
        else
        {
            for(i++; i<G->n(); i++)
            {
                if((G->getmark(i) == 0) && (Distance_temp[i] < Distance_temp[v]))
                {
                    v = i;
                }
            }
        }
        return v;
    }

public:
    RouteSearch(int numvert);
    ~RouteSearch();
    void cleararray(bool temp_array);
    //void getallnumber(int source, int destination, const QList<Station> &fullstationlist, const int station_index[]);
    void getallnumber(int source, int destination, const QList<Station> &fullstationlist, const QVector<int> station_index);
    void dijkstra(Graphm* G, int s, bool forcompare);
    //void search(Graphm* G, const QList<Station> &fullstationlist, const int station_index[], int s, int d);
    void search(Graphm* G, const QList<Station> &fullstationlist, const QVector<int> station_index, int s, int d);
    //void printdistance();
    //void printroute(vector<Station>* list);
    //void printresult(vector<Station>* list);
    void getresult(QList<int>* routestationlist);//, const QList<Station> &stationlist);
};

#endif // ROUTESEARCH_H
