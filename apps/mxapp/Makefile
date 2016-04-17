
CXX=g++
SOURCE=mxapp.mm
FLAGS= `pkg-config mx sdl --cflags --libs` -lobjc

all:
	$(CXX) $(SOURCE) $(FLAGS) -o mxtest
clean:
	rm -rf *~ *.o mxtest

