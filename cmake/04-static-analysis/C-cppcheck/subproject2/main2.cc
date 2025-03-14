#include <iostream>

int main(int argc, char *argv[])
{
   std::cout << "Hello Main2!" << std::endl;
   char tmp[10];
   tmp[11] = 's';  // NOLINT
   return 0;
}
