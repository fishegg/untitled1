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
    ~Routesearch();
    void getallnumber(int source, int destination, QList<Station> *stationlist);
    void dijkstra(Graphm* G, int s, bool forcompare);
    void search(Graphm* G, QList<Station>* stationlist, string s, string d);
    //void printdistance();
    //void printroute(vector<Station>* list);
    //void printresult(vector<Station>* list);
    QStack getresult();
};

#endif // ROUTESEARCH_H
