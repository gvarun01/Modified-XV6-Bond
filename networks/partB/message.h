#ifndef HEADER_H
#define HEADER_H

#define MAX_CHUNK_SIZE 10
#define TIMEOUT 0.1
#define MAX_PENDING_ACKS 1024
#define CIRCULAR_BUFFER_SIZE 4096
#define MAX_DATA_SIZE 1024

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/time.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/socket.h>
#include <stdbool.h>

typedef struct {
    long long int seq_num;
    long long int total_chunks;
    char data[MAX_CHUNK_SIZE];
} data_chunk;

typedef struct {
    long long int seq_num;
    struct timeval sent_time;
} PendingACK;

typedef struct {
    char *data;
    int size;
    int capacity;
    int head;
    int tail;
} CircularBuffer;

#endif