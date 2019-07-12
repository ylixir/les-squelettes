#include <iostream>
#include <vector>
#include <string>

using namespace std;

int main(int argc, char** argv)
{
  string me(*argv);
  vector<string> args(argv + 1, argv + argc);

  cout << "in " << me << endl;

  for(auto arg:args) {
    cout << "hello " << arg << endl;
  }
}
