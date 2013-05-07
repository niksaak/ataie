NAME := ataie
EXE = bin/$(NAME)
BUILD := debug

CFLAGS = -std=c99 -Iaie/include/ -Wall -pedantic -fno-diagnostics-show-caret
LDFLAGS = -Wl,-Bstatic -Laie/lib/ -laie -Wl,-Bdynamic

ifeq ($(BUILD), debug)
  CFLAGS += -O0 -g3 -DDEBUG_MODE
else ifeq ($(BUILD), release)
  CFLAGS += -O3
endif

SOURCES = $(wildcard src/*.c)
OBJECTS = $(SOURCES:.c=.o)

.PHONY: all debug release lint aie clean

all: $(EXE)

debug:
	$(MAKE) -B BUILD=debug all

release:
	$(MAKE) -B BUILD=release all

lint:
	$(CC) $(CFLAGS) -fsyntax-only $(SOURCES)

aie:
	$(MAKE) BUILD=$(BUILD) -C aie/ all

$(EXE): $(OBJECTS) 
	$(CC) -o $@ $(OBJECTS) $(LDFLAGS)

$(OBJECTS): aie

clean:
	@-$(RM) -v $(OBJECTS) ;\
	  $(RM) -v $(NAME) ;\
	  $(MAKE) -C aie/ clean
