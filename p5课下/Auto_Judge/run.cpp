#include <bits/stdc++.h>

using namespace std;

char s[10086];
int cnt = 0;

int main(){
	while(1){
		system("gen.exe");
		system("java -jar Mars_Changed.jar db mc CompactDataAtZero nc test.asm > m.out");
		system("java -jar Mars_Changed.jar mc CompactDataAtZero a dump .text HexText code.txt test.asm > log.txt");
		system("iverilog -o tb.out -I C:\\Users\\hys\\Desktop\\P5自动化测试\\cpu_p5_1.0 -y C:\\Users\\hys\\Desktop\\P5自动化测试\\cpu_p5_1.0 C:\\Users\\hys\\Desktop\\P5自动化测试\\cpu_p5_1.0\\mips_tb.v");
		system("vvp tb.out > v.out");
		system("del.exe");
		system("fc v.out m.out > log.txt");
		freopen("log.txt", "r", stdin);
		gets(s), gets(s);
		printf("test%d:", ++cnt);
		if(s[0] != 'F'){
			puts("Wrong Answer!");
			break;
		}
		puts("Accepted!");
	}
}
