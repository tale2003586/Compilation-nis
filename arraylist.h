# include <stdio.h>
# include <ctype.h>
# include <string.h>
# include <stdlib.h>
#ifndef ARRAYLIST_H
#define ARRAYLIST_H

// 这里是 arraylist.h 文件的内容

#define INIT_SIZE 15
#define EXTEND_radio 2
// 结构体定义和其他内容


struct element
{
    void* data;
};
struct arraylist
{
    int num;

    int size;

    struct element* elements;
    
};


typedef struct arraylist* Arraylist;


Arraylist init_arraylist();

Arraylist append_arraylist(void* value,Arraylist list);

void* get_arraylist(int index,Arraylist list);

Arraylist remove_arraylist(int index,Arraylist list);

int getnum_arraylist(Arraylist list);

int indexof_arraylist(void* value,Arraylist list);

int getsize_arraylist(Arraylist list);

#endif /* ARRAYLIST_H */