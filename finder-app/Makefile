

CC= aarch64-none-linux-gnu-gcc






SRC= writer.c
TARGET = writer
#LDFLAGS = -I/usr/aarch64-linux-gnu/include/syslog.h

#INCLUDE_PATH = /usr/aarch64-linux-gnu/include/syslog.h
INCLUDE_PATH = /usr/aarch64-linux-gnu/include
# Specify the library path and library name
#LIBRARY_PATH = /usr/aarch64-linux-gnu/lib
#LIBS = -lsyslog

native: $(TARGET)
	gcc $(SRC) -o $(TARGET)

cross_compile: $(TARGET)
#$(TARGET): $(SRC) 
	$(CC) $(SRC) -I$(INCLUDE_PATH)  -o $(TARGET)

clean:
	rm -f $(TARGET)

