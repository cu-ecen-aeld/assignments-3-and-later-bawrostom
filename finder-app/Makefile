SRC = writer.c
TARGET = writer

CROSS_COMPILE ?= native


all: $(TARGET)

ifeq ($(CROSS_COMPILE), native)
$(TARGET): $(SRC)
	gcc $(SRC) -o $(TARGET)
endif

ifeq ($(CROSS_COMPILE), aarch64-none-linux-gnu-)
$(TARGET): $(SRC)
	aarch64-none-linux-gnu-gcc $(SRC) -o $(TARGET)
endif

native: $(TARGET)
	gcc $(SRC) -o $(TARGET)

clean:
	rm -f $(TARGET)
