#include<stdio.h>
#include<stdlib.h>
int n;
typedef struct  b{
	int k;
	int j;
}b;
b arr[1000];
int cmp(const void * a, const void*c){
		int t1 = ((b*)a)->k ;
		int t2 = ((b*)c)->k;
		int t3= ((b*)a)->j ;
		int t4 = ((b*)c)->j;
		if(t2>t1)return 1;
		else if(t2==t1){
			if(t4>t3)return 1;
		}
		return -1;
}
int main()
{
	scanf("%d",&n);
	for(int i=0;i<n;i++)
		scanf("%d%d",&arr[i].k,&arr[i].j);
	qsort(arr,n,sizeof(arr[0]),cmp);
	for(int i=0;i<n;i++)
		printf("%d %d\n",arr[i].k,arr[i].j);
	
}
