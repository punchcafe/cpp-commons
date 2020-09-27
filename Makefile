CC := g++
SRCDIR := src
HEADERDIR := $(SRCDIR)/public
BUILDDIR := build
ARDUINOBUILDDIR := $(BUILDDIR)/arduino
TESTDIR := test
ARDUINOLIBNAME := p-commons
FLATTENEDSOURCECODEDIR := tmp/src-stage
ARDUINOIDELIBDIR := /Users/punchcafe/Documents/Arduino/libraries/
PROGNAME := punchcafe-commons
OBJECTCODEDIR := obj

objects := $(subst .h,.o,\
				$(subst $(HEADERDIR)/,$(OBJECTCODEDIR)/,\
					$(wildcard $(HEADERDIR)/*.h) $(wildcard $(HEADERDIR)/*/*.h) $(wildcard $(HEADERDIR)/*/*/*.h)\
					$(wildcard $(HEADERDIR)/*/*/*/*.h) $(wildcard $(HEADERDIR)/*/*/*/*/*.h) $(wildcard $(HEADERDIR)/*/*/*/*/*/*.h)\
					$(wildcard $(HEADERDIR)/*/*/*/*/*/*/*.h) $(wildcard $(HEADERDIR)/*/*/*/*/*/*/*/*.h) $(wildcard $(HEADERDIR)/*/*/*/*/*/*/*/*/*/*/*.h)))

target := $(PROGNAME)

build : $(objects)
	$(CC) $(objects) -o $(PROGNAME)

build-space :
	mkdir $(BUILDDIR)

showme :
	echo "$(objects)"

moveme : tmp
	mkdir tmp/folder
	touch tmp/folder/1
	mv tmp/folder/1 tmp/fulder/1


$(OBJECTCODEDIR) :
	mkdir $(OBJECTCODEDIR)

$(objects) : flattened-src-code $(OBJECTCODEDIR)
	echo $@
	cp -a $(FLATTENEDSOURCECODEDIR)/. $(OBJECTCODEDIR)/
	$(CC) -c $(subst .o,.cpp,$@) -o $@;

tmp :
	mkdir tmp

tmp/f1 temp/f2 : tmp
	touch tmp/f1
	touch tmp/f2

tmp-src-stage : tmp
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


tmp-test-dir : tmp
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
	rm -rf $(OBJECTCODEDIR)

