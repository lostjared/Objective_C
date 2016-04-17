CC=gcc
SDLCONFIG=sdl-config
FILE=sdlapp


all:
	$(CC) `$(SDLCONFIG) --cflags` $(FILE).m -c
	$(CC) $(FILE).o `$(SDLCONFIG) --static-libs`  -o $(FILE) -lobjc

clean:
	rm -rf *~ *.o sdlapp


