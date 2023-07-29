

CC= aarch64-none-linux-gnu-gcc


SRC= writer.c
TARGET = writer



native: $(TARGET)
	gcc $(SRC) -o $(TARGET)

cross_compile: $(TARGET)
	$(CC) $(SRC) -o $(TARGET)
clean:
	rm -f $(TARGET)

