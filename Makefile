# Variables
CC = gcc
CFLAGS = -Wall -O2
TARGET = testbench
SRCS = testbench.c
OBJS = $(SRCS:.c=.o)

# Default target
all: $(TARGET)

# Compile the target
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

# Compile .c files to .o files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean target to remove compiled files
clean:
	rm -f $(OBJS) $(TARGET)

# Run target to execute the testbench
run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run
