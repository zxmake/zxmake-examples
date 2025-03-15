#include <stdio.h>
#include <stdlib.h>

void potential_memory_leak() {
    int *ptr = (int *)malloc(sizeof(int) * 10);
    if (!ptr) {
        return;  // 这里可能导致内存泄漏
    }
    // 没有 free(ptr)
}

int use_after_free() {
    int *ptr = (int *)malloc(sizeof(int));
    if (!ptr) {
        return -1;
    }
    *ptr = 42;
    free(ptr);
    return *ptr;  // 释放后访问
}

int main() {
    potential_memory_leak();
    printf("Use after free: %d\n", use_after_free());
    return 0;
}
