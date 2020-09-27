//#define CATCH_CONFIG_MAIN  // This tells Catch to provide a main() - only do this in one cpp file
//#include "catch.hpp"

#include "SimpleExample.h"
#include "SimpleExample.cpp"
#include <assert.h>
#include <stdio.h>

int main () {
    SimpleExample se;
    assert(se.add(1,3) == 4);
    printf("Assertion Passed!\n");
}

/*
TEST_CASE( "Simple Example works", "[factorial]" ) {
    SimpleExample simpleExample;

    REQUIRE( simpleExample.add(1,2) == 3 );
}
*/