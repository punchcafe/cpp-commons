CC := g++
SRCDIR := src
BUILDDIR := build
ARDUINOBUILDDIR := $(BUILDDIR)/arduino
TESTDIR := test
ARDUINOLIBNAME := p-commons
FLATTENEDSOURCECODEDIR := tmp/src-stage
ARDUINOIDELIBDIR := /Users/punchcafe/Documents/Arduino/libraries/


build-space :
	mkdir $(BUILDDIR)

tmp-space :
	mkdir tmp



tmp-src-stage : tmp-space
	mkdir tmp/src-stage

flattened-src-code : tmp-src-stage
	cp -a src/cpp/. tmp/src-stage/
	cp -a src/public/. tmp/src-stage/

compiled-code : flattened-src-code bin-space
	$(CC) -I./ -o bin/obj tmp/src-stage/*

build-arduino : keywords.txt test

publish-to-arduino-local : build-arduino
	cp -r $(ARDUINOBUILDDIR)/$(ARDUINOLIBNAME) $(ARDUINOIDELIBDIR)$(ARDUINOLIBNAME)


bin-space :
	mkdir bin


tmp-test-dir : tmp-space
	mkdir tmp/test

test-obj : tmp-test-dir flattened-src-code
	mkdir tmp/test/src
	cp -a tmp/src-stage/. tmp/test/src
	cp lib/catch.hpp tmp/test/src/catch.hpp
	cp test/SimpleExample_test.cpp tmp/test/src/SimpleExample_test.cpp
	CC -o tmp/test/test-obj tmp/test/src/SimpleExample_test.cpp

test: test-obj
	./tmp/test/test-obj

arduino-build-space : build-space
	mkdir $(ARDUINOBUILDDIR)

arduino-library-dir : arduino-build-space
	mkdir $(ARDUINOBUILDDIR)/$(ARDUINOLIBNAME)

arduino-copy-files : arduino-library-dir flattened-src-code
	cp -a $(FLATTENEDSOURCECODEDIR)/. $(ARDUINOBUILDDIR)/$(ARDUINOLIBNAME)

keywords.txt : arduino-copy-files
	java -jar .build-tooling/keygentxt.jar ./src >> $(ARDUINOBUILDDIR)/$(ARDUINOLIBNAME)/keywords.txt

clean:
	rm -rf $(BUILDDIR)
	rm -rf tmp
	rm -rf bin

