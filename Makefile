CXX      := g++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra -pedantic -Iinclude -Iui
LDFLAGS  :=

SRC      := $(wildcard src/*.cpp)
OBJ      := $(SRC:.cpp=.o)
BIN      := parser_cli
WX_BIN   := parser_wx

all: $(BIN)

$(BIN): $(OBJ) app/test_cli.o
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

app/test_cli.o: app/test_cli.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

src/%.o: src/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

wx:
	$(CXX) $(CXXFLAGS) $(SRC) ui/parser_teste.cpp app/wx_parser_app.cpp -o $(WX_BIN) `wx-config --cxxflags --libs`

clean:
	rm -f $(OBJ) app/test_cli.o $(BIN) $(WX_BIN)
