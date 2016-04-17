CXX=g++ 
CFLAGS= -O2 `pkg-config mx sdl --cflags`
LDFLAGS= `pkg-config mx --libs`  `sdl-config --static-libs` -lobjc

all:
	$(CXX) $(CFLAGS) screen.mm  -o screen  $(LDFLAGS)
clean:
	rm -rf *.o *~ screen




