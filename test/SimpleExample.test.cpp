#include "SimpleExample.cpp"
#include <assert.h>
#include <stdio.h>

int main () {
    SimpleExample se;
    assert(se.add(1,3) == 4);
    printf("Assertion Passed!\n");
}