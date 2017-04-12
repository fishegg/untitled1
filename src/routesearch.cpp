#include "routesearch.h"

RouteSearch::RouteSearch(int numvert)
{
    int i;
    vertex = numvert;
    Distance = new int[numvert];
    Distance_temp = new int[numvert];
    From = new int[numvert];
    From_temp = new int[numvert];
    for(i=0; i<numvert; i++){
        Distance[i] = 99999;
        Distance_temp[i] = 99999;
        From[i] = i;
        From_temp[i] = i;
    }
    source = -1;
    destination = -1;
}

RouteSearch::~RouteSearch(){
    //cout<<"~Route_search"<<endl;
    delete [] Distance;
    //qDebug() << "delete Distance";
    Distance = nullptr;
    delete [] Distance_temp;
    //qDebug() << "delete Distance temp";
    Distance_temp = nullptr;
    delete [] From;
    //qDebug() << "delete From";
    From = nullptr;
    delete [] From_temp;
    //qDebug() << "delete From temp";
    From_temp = nullptr;
}

void RouteSearch::cleararray(bool temp_array)
{
    for(int i=0; i<vertex; i++){
        if(!temp_array)
        {
            Distance[i] = 99999;
            From[i] = i;
        }
        else
        {
            Distance_temp[i] = 99999;
            From_temp[i] = i;
        }
    }
}

void RouteSearch::getallnumber(int s, int d, const QList<Station> &fullstationlist, const QVector<int> station_index){
    //cout<<"conv"<<endl;
    int i;
    //bool source_done = false, destination_done = false;//记录起点终点转换好没有
    Station station_temp;

    //qDebug()<<"station index"<<station_index[s];
    station_temp = fullstationlist.at(station_index.at(s));
    for(i=0; i<station_temp.linecount(); i++){//看看这个站有多少条线
        switch(i){
        case 0:
            source_list.enqueue(station_temp.number());//记录起点编号
            //qDebug() << "source" << i << source_list.at(i);
            break;
        default:
            source_list.enqueue(station_temp.interchangeat(i));//保存另外的线路对于那个站的编号
            //qDebug() << "source" << i << source_list.at(i);
            break;
        }
    }

    station_temp = fullstationlist.at(station_index.at(d));
    for(i=0; i<station_temp.linecount(); i++){//看看这个站有多少条线
        switch(i){
        case 0:
            destination_list.enqueue(station_temp.number());//记录终点编号
            //qDebug() << "destination" << i << destination_list.at(i);
            break;
        default:
            destination_list.enqueue(station_temp.interchangeat(i));//保存另外的线路对于那个站的编号
            //qDebug() << "destination" << i << destination_list.at(i);
            break;
        }
    }
}

void RouteSearch::dijkstra(Graphm *G, int s, bool use_temp_array){
    //qDebug()<<"dijkstra start";
    int i, v, w;
    G->clearmark();
    cleararray(use_temp_array);

    if(!use_temp_array){
        //cout<<"!temp"<<endl;
        Distance[s] = 0;
        for(i=0; i<G->n(); i++){
            v = minvertex(G, use_temp_array);
            if(Distance[v] == 99999)
                return;
            G->setmark(v, 1);
            for(w=G->first(v); w<G->n(); w=G->next(v,w)){
                if(Distance[w] > (Distance[v] + G->weight(v,w))){
                    Distance[w] = Distance[v] + G->weight(v,w);
                    From[w] = v;
                }
            }
        }
    }

    else{
        //cout<<"temp"<<endl;
        Distance_temp[s] = 0;
        for(i=0; i<G->n(); i++){
            v = minvertex(G, use_temp_array);
            if(Distance_temp[v] == 99999)
                return;
            G->setmark(v, 1);
            for(w=G->first(v); w<G->n(); w=G->next(v,w)){
                if(Distance_temp[w] > (Distance_temp[v] + G->weight(v,w))){
                    Distance_temp[w] = Distance_temp[v] + G->weight(v,w);
                    From_temp[w] = v;
                }
            }
        }
    }
    //qDebug()<<"finished";
}

void RouteSearch::search(Graphm* G, const QList<Station> &fullstationlist, const QVector<int> station_index, int s, int d){
    getallnumber(s,d,fullstationlist,station_index);

    if(source_list.size() == 0 && destination_list.size() == 0){
        //cout<<"source1="<<source<<endl;
        source = source_list.dequeue();
        destination = destination_list.dequeue();
        //source_list.dequeue();
        //destination_list.dequeue();
        dijkstra(G, source, false);
    }

    else if(source_list.size() > 0 && destination_list.size() == 0){
        //cout<<"interchange source"<<endl;
        source = source_list.dequeue();
        destination = destination_list.dequeue();
        //source_list.dequeue();
        //destination_list.dequeue();
        dijkstra(G, source, false);
        int n = source_list.size(), source_temp;
        //cout<<"n"<<n<<endl;
        int i, j;
        for(i=0; i<n; i++){
            //cout<<"i"<<i<<endl;
            source_temp = source_list.dequeue();//从这个站另一条线出发
            //source_list.dequeue();
            //cout<<"dequeued"<<endl;
            //cout<<"sourcen="<<source_temp<<endl;
            dijkstra(G, source_temp, true);
            if(Distance[destination] > Distance_temp[destination]){//如果这条线比较近
                source = source_temp;
                for(j=0; j<fullstationlist.size(); j++){
                    Distance[j] = Distance_temp[j];
                    From[j] = From_temp[j];
                }
            }
        }
    }

    else if(source_list.size() == 0 && destination_list.size() > 0){
        //cout<<"intechange destination"<<endl;
        source = source_list.dequeue();
        destination = destination_list.dequeue();
        //source_list.dequeue();
        //destination_list.dequeue();
        dijkstra(G, source, false);
        int n = destination_list.size(), destination_temp;
        //cout<<"n"<<n<<endl;
        int i, j;
        for(i=0; i<n; i++){
            //cout<<"i"<<i<<endl;
            destination_temp = destination_list.dequeue();
            //destination_list.dequeue();
            //cout<<"dequeued"<<endl;
            dijkstra(G, source, true);
            if(Distance[destination] > Distance_temp[destination_temp]){
                destination = destination_temp;
                for(j=0; j<fullstationlist.size(); j++){
                    Distance[j] = Distance_temp[j];
                    From[j] = From_temp[j];
                }
            }
        }
    }

    else if(source_list.size() > 0 && destination_list.size() > 0){
        //cout<<"both interchanges"<<endl;
        source = source_list.dequeue();
        destination = destination_list.dequeue();
        //source_list.dequeue();
        //destination_list.dequeue();
        source_list.enqueue(source);
        destination_list.enqueue(destination);
        //qDebug() << "source destination" << source << " " << destination;

        dijkstra(G, source, false);

        int source_count = source_list.size(), destination_count = destination_list.size(),source_temp, destination_temp;
        int i, j, k;
        for(i=0; i<source_count; i++){
            source_temp = source_list.dequeue();
            //source_list.dequeue();
            for(j=0; j<destination_count; j++){
                destination_temp = destination_list.dequeue();
                //destination_list.dequeue();
                dijkstra(G, source_temp, true);
                //qDebug() << "distance" << Distance[destination];
                //qDebug() << "distance_temp" << Distance_temp[destination_temp];
                if(Distance[destination] > Distance_temp[destination_temp]){
                    source = source_temp;
                    destination = destination_temp;
                    for(k=0; k<fullstationlist.size(); k++){
                        Distance[k] = Distance_temp[k];
                        From[k] = From_temp[k];
                    }
                    //qDebug() << "source destination" << source << " " << destination;
                }
                destination_list.enqueue(destination_temp);
            }
        }
    }
    //qDebug() << "source destination" << source << " " << destination;
    //qDebug() << "distance" << Distance[destination];
    //qDebug() << "From[destination]" << From[destination];
    //qDebug() << "search finish";
}

void RouteSearch::getresult(QList<int>* routestationlist)//, const QList<Station> &fullstationlist)
{
    qDebug() << "getresult start";
    QStack<int> route;
    //Station station_temp;
    int station_number_temp;
    //int i;
    int prev = destination;
    int station_via_count = 0;
    routestationlist->clear();
    do
    {
        if(prev == From[prev])
        {
            break;
        }
        route.push(prev);
        prev = From[prev];
        station_via_count++;
        //qDebug() << "number" << prev;
        //qDebug() << "via" << station_via_count;
    }while(prev != source);
    station_via_count++;
    route.push(prev);
    qDebug() << "first loop";

    //qDebug() << "while(!route.isEmpty())";
    while(!route.isEmpty())
    {
        station_number_temp = route.pop();
        //station_temp = stationlist.at(station_number_temp);
        routestationlist->append(station_number_temp);
    }
    qDebug() << "second loop";

    /*for (i = 0; i < routestationlist->size(); ++i) {
        station_temp = stationlist.at(i);
        qDebug() << station_temp.stationnumber();
    }*/
    //qDebug() << "third loop";
    qDebug() << "get result finish";
}
