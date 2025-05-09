NAME = libaidl-common

SOURCES = \
    aidl_checkapi.cpp \
    aidl_const_expressions.cpp \
    aidl_dumpapi.cpp \
    aidl_language_l.cpp \
    aidl_language_y.cpp \
    aidl_language.cpp \
    aidl_to_common.cpp \
    aidl_to_cpp_common.cpp \
    aidl_to_cpp.cpp \
    aidl_to_java.cpp \
    aidl_to_ndk.cpp \
    aidl_to_rust.cpp \
    aidl_typenames.cpp \
    aidl.cpp \
    ast_java.cpp \
    check_valid.cpp \
    code_writer.cpp \
    comments.cpp \
    diagnostics.cpp \
    generate_aidl_mappings.cpp \
    generate_cpp.cpp \
    generate_cpp_analyzer.cpp \
    generate_java_binder.cpp \
    generate_java.cpp \
    generate_ndk.cpp \
    generate_rust.cpp \
    import_resolver.cpp \
    io_delegate.cpp \
    location.cpp \
    logging.cpp \
    options.cpp \
    parser.cpp \
    permission.cpp \
    preprocess.cpp

INCLUDES  += -I/usr/include/android
CXXFLAGS  += -std=c++17 -O0 -g -fPIC -Wno-error
LDFLAGS   += -shared \
             -Wl,-soname,$(NAME).so.0 \
             -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
             -L/usr/lib/$(DEB_HOST_MULTIARCH)/android -lbase -lcutils -llog -lgtest

all: parser_headers $(NAME).so

parser_headers: aidl_language_y.yy
	bison -o aidl_language_y.cpp --defines=aidl_language_y.h aidl_language_y.yy
	ln -sf aidl_language_y.h aidl_language_y.hpp

aidl_language_l.cpp: aidl_language_l.ll parser_headers
	flex -o aidl_language_l.cpp aidl_language_l.ll

$(NAME).so: aidl_language_l.cpp aidl_language_y.cpp $(SOURCES)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(INCLUDES) \
	       $(SOURCES) -o $(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 $(NAME).so

clean:
	rm -f $(NAME).so.0 $(NAME).so \
	      aidl_language_l.cpp aidl_language_y.cpp \
	      aidl_language_y.h aidl_language_y.hpp
