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

void RouteSearch::cleararray(const bool &temp_array)
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

bool RouteSearch::getallnumber(const int &s, const int &d, const QList<Station> &fullstationlist, const QVector<int> &station_index){
    //cout<<"conv"<<endl;
    //int i;
    //bool source_done = false, destination_done = false;//记录起点终点转换好没有
    Station station_temp;

    //qDebug()<<"station index"<<station_index[s];
    station_temp = fullstationlist.at(station_index.at(s));
    /*for(i=0; i<station_temp.linecount(); i++){//看看这个站有多少条线
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
    }*/
    source_list.enqueue(station_temp.number());
    if(station_temp.interchangeat(1) != -1)
        source_list.enqueue(station_temp.interchangeat(1));
    if(station_temp.interchangeat(2) != -1)
        source_list.enqueue(station_temp.interchangeat(2));
    if(station_temp.interchangeat(3) != -1)
        source_list.enqueue(station_temp.interchangeat(3));
    if(station_temp.unpaidinterchangeat(1) != -1)
        source_list.enqueue(station_temp.unpaidinterchangeat(1));
    if(station_temp.unpaidinterchangeat(2) != -1)
        source_list.enqueue(station_temp.unpaidinterchangeat(2));
    if(station_temp.unpaidinterchangeat(3) != -1)
        source_list.enqueue(station_temp.unpaidinterchangeat(3));
    if(source_list.size() != station_temp.linecount())
    {
        return false;
    }


    station_temp = fullstationlist.at(station_index.at(d));
    /*for(i=0; i<station_temp.linecount(); i++){//看看这个站有多少条线
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
    }*/
    destination_list.enqueue(station_temp.number());
    if(station_temp.interchangeat(1) != -1)
        destination_list.enqueue(station_temp.interchangeat(1));
    if(station_temp.interchangeat(2) != -1)
        destination_list.enqueue(station_temp.interchangeat(2));
    if(station_temp.interchangeat(3) != -1)
        destination_list.enqueue(station_temp.interchangeat(3));
    if(station_temp.unpaidinterchangeat(1) != -1)
        destination_list.enqueue(station_temp.unpaidinterchangeat(1));
    if(station_temp.unpaidinterchangeat(2) != -1)
        destination_list.enqueue(station_temp.unpaidinterchangeat(2));
    if(station_temp.unpaidinterchangeat(3) != -1)
        destination_list.enqueue(station_temp.unpaidinterchangeat(3));
    if(destination_list.size() != station_temp.linecount())
    {
        return false;
    }

    return true;
}

void RouteSearch::dijkstra(Graphm *G, const int &s, const int &p, const int &multiple, const bool &use_temp_array){
    //qDebug()<<"dijkstra start";
    //qDebug()<<"source"<<s<<"prefer"<<p<<"multiple"<<multiple<<"compare"<<use_temp_array;
    int i, v, w;
    G->clearmark();
    cleararray(use_temp_array);

    if(p == ConvenientlyTransfer){
        int replaced_weight;
        if(!use_temp_array){
            //cout<<"!temp"<<endl;
            Distance[s] = 0;
            for(i=0; i<G->n(); i++){
                v = minvertex(G, use_temp_array);
                if(Distance[v] == 99999)
                    return;
                G->setmark(v, 1);
                for(w=G->first(v); w<G->n(); w=G->next(v,w)){
                    if(G->weight(v,w) < 200){
                        replaced_weight = G->weight(v,w);
                    }
                    else if(G->weight(v,w) == 200 || G->weight(v,w) == 300){
                        replaced_weight = 300;
                    }
                    else if(G->weight(v,w) > 300 && G->weight(v,w) < 99999){
                        replaced_weight = 1;
                    }
                    else{
                        replaced_weight = G->weight(v,w);
                    }
                    if(Distance[w] > (Distance[v] + replaced_weight)){
                        Distance[w] = Distance[v] +replaced_weight;
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
                    if(G->weight(v,w) < 200){
                        replaced_weight = G->weight(v,w);
                    }
                    else if(G->weight(v,w) == 200 || G->weight(v,w) == 300){
                        replaced_weight = 300;
                    }
                    else if(G->weight(v,w) > 300 && G->weight(v,w) < 99999){
                        replaced_weight = 1;
                    }
                    else{
                        replaced_weight = G->weight(v,w);
                    }
                    if(Distance_temp[w] > (Distance_temp[v] + replaced_weight)){
                        Distance_temp[w] = Distance_temp[v] + replaced_weight;
                        From_temp[w] = v;
                    }
                }
            }
        }
    }

    else if(p == LessTimeTransfer){
        int replaced_weight;
        if(!use_temp_array){
            //cout<<"!temp"<<endl;
            Distance[s] = 0;
            for(i=0; i<G->n(); i++){
                v = minvertex(G, use_temp_array);
                if(Distance[v] == 99999)
                    return;
                G->setmark(v, 1);
                for(w=G->first(v); w<G->n(); w=G->next(v,w)){
                    if(G->weight(v,w) < 200){
                        replaced_weight = 1000;
                    }
                    else if(G->weight(v,w) == 200 || G->weight(v,w) == 300){
                        replaced_weight = 2000;
                    }
                    else if(G->weight(v,w) > 300 && G->weight(v,w) < 99999){
                        replaced_weight = 1;
                    }
                    else{
                        replaced_weight = G->weight(v,w);
                    }
                    if(Distance[w] > (Distance[v] + replaced_weight)){
                        Distance[w] = Distance[v] + replaced_weight;
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
                    if(G->weight(v,w) < 200){
                        replaced_weight = 1000;
                    }
                    else if(G->weight(v,w) == 200 || G->weight(v,w) == 300){
                        replaced_weight = 2000;
                    }
                    else if(G->weight(v,w) > 300 && G->weight(v,w) < 99999){
                        replaced_weight = 1;
                    }
                    else{
                        replaced_weight = G->weight(v,w);
                    }
                    if(Distance_temp[w] > (Distance_temp[v] + replaced_weight)){
                        Distance_temp[w] = Distance_temp[v] + replaced_weight;
                        From_temp[w] = v;
                    }
                }
            }
        }
    }

    else if(p == ShortDistance){
        int replaced_weight;
        if(!use_temp_array){
            int replaced_weight;
            Distance[s] = 0;
            for(i=0; i<G->n(); i++){
                v = minvertex(G, use_temp_array);
                for(w=G->first(v); w<G->n(); w=G->next(v,w)){
                    if(Distance[v] == 99999)
                        return;
                    G->setmark(v, 1);
                    if(G->weight(v,w) < 300){
                        replaced_weight = 1;
                    }
                    else if(G->weight(v,w) == 200 || G->weight(v,w) == 300){
                        replaced_weight = 1;
                    }
                    else if(G->weight(v,w) > 300 && G->weight(v,w) < 99999){
                        replaced_weight = G->weight(v,w);
                    }
                    else{
                        replaced_weight = G->weight(v,w);
                    }
                    if(Distance[w] > (Distance[v] + replaced_weight)){
                        Distance[w] = Distance[v] + replaced_weight;
                        From[w] = v;
                    }
                }
            }
        }

        else{
            Distance_temp[s] = 0;
            for(i=0; i<G->n(); i++){
                v = minvertex(G, use_temp_array);
                if(Distance_temp[v] == 99999)
                    return;
                G->setmark(v, 1);
                for(w=G->first(v); w<G->n(); w=G->next(v,w)){
                    if(G->weight(v,w) < 200){
                        replaced_weight = 1;
                    }
                    else if(G->weight(v,w) == 200 || G->weight(v,w) == 300){
                        replaced_weight = 1;
                    }
                    else if(G->weight(v,w) > 300 && G->weight(v,w) < 99999){
                        replaced_weight = G->weight(v,w);
                    }
                    else{
                        replaced_weight = G->weight(v,w);
                    }
                    if(Distance_temp[w] > (Distance_temp[v] + replaced_weight)){
                        Distance_temp[w] = Distance_temp[v] + replaced_weight;
                        From_temp[w] = v;
                    }
                }
            }
        }
    }

    else if(p == Balance){
        int replaced_weight;
        if(!use_temp_array){
            //cout<<"!temp"<<endl;
            Distance[s] = 0;
            for(i=0; i<G->n(); i++){
                v = minvertex(G, use_temp_array);
                if(Distance[v] == 99999)
                    return;
                G->setmark(v, 1);
                for(w=G->first(v); w<G->n(); w=G->next(v,w)){
                    if(G->weight(v,w) <= 300){
                        replaced_weight = G->weight(v,w) * multiple;
                    }
                    else{
                        replaced_weight = G->weight(v,w);
                    }
                    if(Distance[w] > (Distance[v] + replaced_weight)){
                        Distance[w] = Distance[v] + replaced_weight;
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
                    if(G->weight(v,w) <= 300){
                        replaced_weight = G->weight(v,w) * multiple;
                    }
                    else{
                        replaced_weight = G->weight(v,w);
                    }
                    if(Distance_temp[w] > (Distance_temp[v] + replaced_weight)){
                        Distance_temp[w] = Distance_temp[v] + replaced_weight;
                        From_temp[w] = v;
                    }
                }
            }
        }
    }
    //qDebug()<<"finished";
}

bool RouteSearch::search(Graphm* G, const QList<Station> &fullstationlist, const QVector<int> &station_index, const int &station_count, const int &s, const int &d, const int &p, const int &multiple){
    if(!getallnumber(s,d,fullstationlist,station_index))
        return false;

    if(source_list.size() == 1 && destination_list.size() == 1){
        //cout<<"source1="<<source<<endl;
        source = source_list.dequeue();
        destination = destination_list.dequeue();
        //source_list.dequeue();
        //destination_list.dequeue();
        dijkstra(G, source, p, multiple, false);
    }

    else if(source_list.size() > 1 && destination_list.size() == 1){
        //cout<<"interchange source"<<endl;
        source = source_list.dequeue();
        destination = destination_list.dequeue();
        //source_list.dequeue();
        //destination_list.dequeue();
        dijkstra(G, source, p, multiple, false);
        int n = source_list.size(), source_temp;
        //cout<<"n"<<n<<endl;
        int i, j;
        for(i=0; i<n; i++){
            //cout<<"i"<<i<<endl;
            source_temp = source_list.dequeue();//从这个站另一条线出发
            //source_list.dequeue();
            //cout<<"dequeued"<<endl;
            //cout<<"sourcen="<<source_temp<<endl;
            dijkstra(G, source_temp, p, multiple, true);
            if(Distance[destination] > Distance_temp[destination]){//如果这条线比较近
                source = source_temp;
                for(j=0; j<station_count; j++){
                    Distance[j] = Distance_temp[j];
                    From[j] = From_temp[j];
                }
            }
        }
    }

    else if(source_list.size() == 1 && destination_list.size() > 1){
        //cout<<"intechange destination"<<endl;
        source = source_list.dequeue();
        destination = destination_list.dequeue();
        //source_list.dequeue();
        //destination_list.dequeue();
        dijkstra(G, source, p, multiple, false);
        int n = destination_list.size(), destination_temp;
        //cout<<"n"<<n<<endl;
        int i, j;
        for(i=0; i<n; i++){
            //cout<<"i"<<i<<endl;
            destination_temp = destination_list.dequeue();
            //destination_list.dequeue();
            //cout<<"dequeued"<<endl;
            dijkstra(G, source, p, multiple, true);
            if(Distance[destination] > Distance_temp[destination_temp]){
                destination = destination_temp;
                for(j=0; j<station_count; j++){
                    Distance[j] = Distance_temp[j];
                    From[j] = From_temp[j];
                }
            }
        }
    }

    else if(source_list.size() > 1 && destination_list.size() > 1){
        //cout<<"both interchanges"<<endl;
        source = source_list.dequeue();
        destination = destination_list.dequeue();
        //source_list.dequeue();
        //destination_list.dequeue();
        source_list.enqueue(source);
        destination_list.enqueue(destination);
        //qDebug() << "source destination" << source << " " << destination;

        dijkstra(G, source, p, multiple, false);

        int source_count = source_list.size(), destination_count = destination_list.size(),source_temp, destination_temp;
        int i, j, k;
        for(i=0; i<source_count; i++){
            source_temp = source_list.dequeue();
            //source_list.dequeue();
            for(j=0; j<destination_count; j++){
                destination_temp = destination_list.dequeue();
                //destination_list.dequeue();
                dijkstra(G, source_temp, p, multiple, true);
                //qDebug() << "distance" << Distance[destination];
                //qDebug() << "distance_temp" << Distance_temp[destination_temp];
                //qDebug() << "Distance from" << source << "to" << destination << Distance[destination];
                //qDebug() << "Distance temp from" << source_temp << "to" << destination_temp << Distance_temp[destination_temp];
                if(Distance[destination] > Distance_temp[destination_temp]){
                    source = source_temp;
                    //qDebug() << "original dst" << destination;
                    destination = destination_temp;
                    //qDebug() << "changed dst" << destination;
                    //qDebug() << "before Distance[] Distance[temp]" << Distance[destination] << Distance[destination_temp];
                    //qDebug() << "before Distance_temp[] Distance_temp[temp]" << Distance_temp[destination] << Distance_temp[destination_temp] << endl;
                    for(k=0; k<station_count; k++){
                        Distance[k] = Distance_temp[k];
                        From[k] = From_temp[k];
                    }
                    //qDebug() << "after Distance[] Distance[temp]" << Distance[destination] << Distance[destination_temp];
                    //qDebug() << "after Distance_temp[] Distance_temp[temp]" << Distance_temp[destination] << Distance_temp[destination_temp] << endl;
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
    return true;
}

bool RouteSearch::getresult(QList<int>* routestationlist)//, const QList<Station> &fullstationlist)
{
    qDebug() << "getresult start";
    QStack<int> route;
    //Station station_temp;
    int station_number_temp;
    //int i;
    //qDebug() << "destination" << destination;
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
    //qDebug() << "first loop";

    //qDebug() << "while(!route.isEmpty())";
    while(!route.isEmpty())
    {
        station_number_temp = route.pop();
        //station_temp = stationlist.at(station_number_temp);
        routestationlist->append(station_number_temp);
    }
    //qDebug() << "second loop";

    /*for (i = 0; i < routestationlist->size(); ++i) {
        station_temp = stationlist.at(i);
        qDebug() << station_temp.stationnumber();
    }*/
    //qDebug() << "third loop";
    qDebug() << "get result finish";
    return true;
}
