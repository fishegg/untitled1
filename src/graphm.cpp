#include "graphm.h"

Graphm::Graphm()
{
    Init(1);
}

Graphm::Graphm(int num_vert){
    Init(num_vert);
}

Graphm::~Graphm(){
    //cout<<"~Graphm"<<endl;
    delete [] mark;
    for(int i=0; i<num_vertex; i++){
        delete [] matrix[i];
    }
    delete [] matrix;
    //system("pause");
}

void Graphm::Init(int n){
    int i;
    num_vertex = n;
    num_edge = 0;
    mark = new int[n];
    for(i=0; i<num_vertex; i++){
        mark[i] = 0;
    }
    matrix = (int**) new int*[num_vertex];
    for(i=0; i<num_vertex; i++){
        matrix[i] = new int[num_vertex];
    }
    for(i=0; i<num_vertex; i++){
        for(int j=0; j<num_vertex; j++){
            matrix[i][j] = 0;
        }
    }
}

int Graphm::n(){
    return num_vertex;
}

int Graphm::e(){
    return num_edge;
}

int Graphm::first(int v){
    for(int i=0; i<num_vertex; i++){
        if(matrix[v][i] != 0){
            return i;
        }
    }
    return num_vertex;
}

int Graphm::next(int v, int w){
    for(int i=w+1; i<num_vertex; i++){
        if(matrix[v][i] != 0){
            return i;
        }
    }
    return num_vertex;
}

void Graphm::setedge(int v1, int v2, int wt){
    if(wt != 99999){
        num_edge++;
    }
    //cout<<"setedge"<<v1<<","<<v2<<endl;
    matrix[v1][v2] = wt;
}

void Graphm::deledge(int v1, int v2){
    if(matrix[v1][v2] < 99999){
        num_edge--;
    }
    matrix[v1][v2] = 99999;
}

bool Graphm::isedge(int i, int j){
    return matrix[i][j] != 99999;
}

int Graphm::weight(int v1, int v2){
    return matrix[v1][v2];
}

int Graphm::getmark(int v){
    return mark[v];
}

void Graphm::setmark(int v, int val){
    mark[v] = val;
}

void Graphm::clearmark(){
    int i;
    for(i=0; i<num_vertex; i++){
        mark[i] = 0;
    }
}

void Graphm::qdebugwholegraph()
{
    int i,j;
    for(i=0;i<num_vertex;i++)
    {
        for(j=0;j<num_vertex;j++)
        {
            qDebug() << matrix[i][j] << " ";
        }
        qDebug() << endl;
    }
}
