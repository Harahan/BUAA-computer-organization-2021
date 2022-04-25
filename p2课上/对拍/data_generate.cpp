#include <iostream>
#include <cstdlib>
#include <ctime>
using namespace std;

int main() {
	srand(time(NULL));
	int n = rand() % 998 + 1;
	freopen("in.txt", "w", stdout);
	cout << n << endl;
	for(int i = 0; i < 2*n; i++) cout << rand() << endl;
	return 0;
}
