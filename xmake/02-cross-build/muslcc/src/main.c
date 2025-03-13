#include <ogg/ogg.h>
#include <stdint.h>
#include <stdio.h>
#include <zlib.h>

int main(int argc, char** argv) {
  printf("hello world!\n");
  inflate(0, 0);
  ogg_sync_init(0);
  return 0;
}
