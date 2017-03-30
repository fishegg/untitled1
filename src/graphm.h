#ifndef GRAPHM_H
#define GRAPHM_H
#include <qdebug.h>


class Graphm
{
private:
    int num_vertex, num_edge;
    int **matrix;
    int *mark;
public:
    Graphm();
    Graphm(int num_vert);
    ~Graphm();
    void Init(int n);
    int n();
    int e();
    int first(int v);
    int next(int v, int w);
    void setedge(int v1, int v2, int wt);
    void deledge(int v1, int v2);
    bool isedge(int i, int j);
    int weight(int v1, int v2);
    int getmark(int v);
    void setmark(int v, int val);
    void clearmark();
    void qdebugwholegraph();
};

#endif // GRAPHM_H
