#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
  settickets(atoi(argv[1]));  // Set the number of tickets based on user input

//   for (int i = 0; i < ; i++) {
    printf("Process with %d tickets is running.\n", atoi(argv[1]));
//   }
  
  exit(0);
}