#include "routesearch.h"

RouteSearch::RouteSearch(int numvert)
{
    int i;
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
    Distance = NULL;
    delete [] Distance_temp;
    Distance_temp = NULL;
    delete [] From;
    From = NULL;
    delete [] From_temp;
    From_temp = NULL;
}

void RouteSearch::getallnumber(int s, int d, QList<Station> *stationlist){
    //cout<<"conv"<<endl;
    int i;
    //bool source_done = false, destination_done = false;//记录起点终点转换好没有
    Station station_temp;

    station_temp = stationlist->at(s);
    for(i=0; i<station_temp.linescount(); i++){//看看这个站有多少条线
        switch(i){
        case 0:
            source_list.enqueue(station_temp.number());//记录起点编号
            break;
        default:
            source_list.enqueue(station_temp.samestations(i));//保存另外的线路对于那个站的编号
            break;
        }
    }

    station_temp = stationlist->at(d);
    for(i=0; i<station_temp.linescount(); i++){//看看这个站有多少条线
        switch(i){
        case 0:
            destination_list.enqueue(station_temp.number());//记录终点编号
            break;
        default:
            destination_list.enqueue(station_temp.samestations(i));//保存另外的线路对于那个站的编号
            break;
        }
    }
}

void RouteSearch::dijkstra(Graphm *G, int s, bool use_temp_array){
    //cout<<"dijkstra start"<<endl;
    int i, v, w;
    G->clearmark();

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
    //cout<<"dijkstra finished"<<endl;
}

void RouteSearch::search(Graphm* G, QList<Station>* stationlist, int s, int d){
    getallnumber(s,d,stationlist);

    if(source_list.size() == 0 && destination_list.size() == 0){
        //cout<<"source1="<<source<<endl;
        source = source_list.head();
        destination = destination_list.head();
        source_list.dequeue();
        destination_list.dequeue();
        dijkstra(G, source, false);
    }

    else if(source_list.size() > 0 && destination_list.size() == 0){
        //cout<<"interchange source"<<endl;
        source = source_list.head();
        destination = destination_list.head();
        source_list.dequeue();
        destination_list.dequeue();
        dijkstra(G, source, false);
        int n = source_list.size(), source_temp;
        //cout<<"n"<<n<<endl;
        int i, j;
        for(i=0; i<n; i++){
            //cout<<"i"<<i<<endl;
            source_temp = source_list.head();//从这个站另一条线出发
            source_list.dequeue();
            //cout<<"dequeued"<<endl;
            //cout<<"sourcen="<<source_temp<<endl;
            dijkstra(G, source_temp, true);
            if(Distance[destination] > Distance_temp[destination]){//如果这条线比较近
                source = source_temp;
                for(j=0; j<stationlist->size(); j++){
                    Distance[j] = Distance_temp[j];
                    From[j] = From_temp[j];
                }
            }
        }
    }

    else if(source_list.size() == 0 && destination_list.size() > 0){
        //cout<<"intechange destination"<<endl;
        source = source_list.head();
        destination = destination_list.head();
        source_list.dequeue();
        destination_list.dequeue();
        dijkstra(G, source, false);
        int n = destination_list.size(), destination_temp;
        //cout<<"n"<<n<<endl;
        int i, j;
        for(i=0; i<n; i++){
            //cout<<"i"<<i<<endl;
            destination_temp = destination_list.head();
            destination_list.dequeue();
            //cout<<"dequeued"<<endl;
            dijkstra(G, source, true);
            if(Distance[destination] > Distance_temp[destination_temp]){
                destination = destination_temp;
                for(j=0; j<stationlist->size(); j++){
                    Distance[j] = Distance_temp[j];
                    From[j] = From_temp[j];
                }
            }
        }
    }

    else if(source_list.size() > 0 && destination_list.size() > 0){
        //cout<<"both interchanges"<<endl;
        source = source_list.head();
        destination = destination_list.head();
        source_list.dequeue();
        destination_list.dequeue();
        source_list.enqueue(source);
        destination_list.enqueue(destination);
        dijkstra(G, source, false);
        int source_count = source_list.size(), destination_count = destination_list.size(),source_temp, destination_temp;
        int i, j, k;
        for(i=0; i<source_count; i++){
            source_temp = source_list.head();
            source_list.dequeue();
            for(j=0; j<destination_count; j++){
                destination_temp = destination_list.head();
                destination_list.dequeue();
                dijkstra(G, source_temp, true);
                if(Distance[destination] > Distance_temp[destination_temp]){
                    source = source_temp;
                    destination = destination_temp;
                    for(k=0; k<stationlist->size(); k++){
                        Distance[k] = Distance_temp[k];
                        From[k] = From_temp[k];
                    }
                }
                destination_list.enqueue(destination_temp);
            }
        }
    }
}

/*QStack* getresult()
{
    QStack<int> route;
    int prev = destination;
    int i = 0;
    do
    {
        route.push(prev);
        prev = From[prev];
        i++;
    }while(prev != source);
    route.push(prev);
    return *route;
}*/
