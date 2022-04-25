#include<stdio.h>
int n,arr[1000];
int k=0;
void fac(int n)
{
	int sum;
	arr[0]=1;
	for(int i=2;i<=n;i++){
		int c = 0;
		for(int j=0;j<=k;j++){
			sum = arr[j]*i+c;
			arr[j]=sum%10;
			c= sum/10;
			if(c!=0&&j==k)k++;
		}
	}
}
int main()
{
	scanf("%d",&n);
	fac(n);
	for(int j=k;j>=0;j--)
		printf("%d",arr[j]);
}

