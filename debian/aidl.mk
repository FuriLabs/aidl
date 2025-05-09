NAME = aidl
SOURCES = main.cpp
INCLUDES  += -I/usr/include/android
CXXFLAGS += -std=c++17 -O0 -g -Wno-error
LDFLAGS += -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -L. -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -laidl-common -lbase -llog -lcutils -lgtest -latomic

all: $(NAME)

$(NAME): $(SOURCES) libaidl-common.so
	$(CXX) $(SOURCES) -o $(NAME) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $(INCLUDES)

clean:
	rm -f $(NAME)
