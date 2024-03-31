#include <stdio.h>
#include <stdlib.h>
#include "arraylist.h"


Arraylist init_arraylist(){
    Arraylist thisarraylist = (Arraylist)malloc(sizeof(struct arraylist));
    thisarraylist->elements = (struct element*)malloc(INIT_SIZE*sizeof(struct element));
    if(thisarraylist == NULL){
        printf("malloc error!");
        return NULL;
    }
    if(thisarraylist->elements == NULL){
        printf("malloc error!");
        return NULL;
    }
    for(int i = 0;i< INIT_SIZE;i++){
        thisarraylist->elements[i].data = 0;
    }
    thisarraylist->num = 0;
    thisarraylist->size = INIT_SIZE;
    return thisarraylist;
}

Arraylist append_arraylist(void* value,Arraylist list){
    if(list->num == list->size-1){
        int newcapacity = list->size * EXTEND_radio;
        list->elements = (struct element*)realloc(list->elements,newcapacity*sizeof(struct element));
        if (list->elements !=NULL)
            list->size = newcapacity;
        else{
            printf("realloc error!");
            return list;
        }
    }
    list->elements[list->num].data = value;
    list->num++;
    return list;
}

void* get_arraylist(int index,Arraylist list){
    if(index < list->num){
        return list->elements[index].data;
    }
    else return NULL;
}

Arraylist remove_arraylist(int index,Arraylist list){
    if (index<list->num)
    {
        int next = index+1;
        for (; next < list->num; ++next) {
            list->elements[next-1].data = list->elements[next].data;
        }
    }
    return list;
}

int getnum_arraylist(Arraylist list){
    return list->num;
}

int getsize_arraylist(Arraylist list){
    return list->size;
}

int indexof_arraylist(void* value,Arraylist list){
    int num = getnum_arraylist(list);
    for(int i = 0;i<num;i++){
        if(value == get_arraylist(i,list))
            return i;
    }
    return -1;
}
/*
void main(){
    int a = 10;
    int *p = &a;
    Arraylist list = init_arraylist();
    list = append_arraylist(p,list);
    printf("hello\n");
    printf("%d\n", *(int*)get_arraylist(0,list));
    list = remove_arraylist(0,list);
}
*/