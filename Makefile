CXX      := g++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra -pedantic -Iinclude
LDFLAGS  :=

SRC      := $(wildcard src/*.cpp)
OBJ      := $(SRC:.cpp=.o)
BIN      := parser_cli

all: $(BIN)

$(BIN): $(OBJ) app/test_cli.o
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

app/test_cli.o: app/test_cli.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

src/%.o: src/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) app/test_cli.o $(BIN)
