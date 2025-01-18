#include "message.h"

PendingACK pending_acks[MAX_PENDING_ACKS];
int pending_acks_count = 0;

CircularBuffer received_buffer;

double whatsTheTime()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec + (tv.tv_usec / 1000000.0);
}

void initBuffer(CircularBuffer *buffer, int capacity)
{
    buffer->data = malloc(capacity * sizeof(char));
    if (buffer->data == NULL)
    {
        perror("Failed to allocate memory for circular buffer");
        exit(EXIT_FAILURE);
    }
    buffer->size = 0;
    buffer->capacity = capacity;
    buffer->head = 0;
    buffer->tail = 0;
}

void addtoBuffer(CircularBuffer *buffer, const char *data, int length)
{
    for (int i = 0; i < length; i++)
    {
        buffer->data[buffer->tail] = data[i];
        buffer->tail = (buffer->tail + 1) % buffer->capacity;
        if (buffer->size < buffer->capacity)
        {
            buffer->size++;
        }
        else
        {
            buffer->head = (buffer->head + 1) % buffer->capacity;
        }
    }
}

void clearBuffer(CircularBuffer *buffer)
{
    buffer->head = 0;
    buffer->tail = 0;
    buffer->size = 0;
}

void addAck(long long int seq_num)
{
    if (pending_acks_count < MAX_PENDING_ACKS)
    {
        pending_acks[pending_acks_count].seq_num = seq_num;
        gettimeofday(&pending_acks[pending_acks_count].sent_time, NULL);
        pending_acks_count++;
    }
}

void removeAck(long long int seq_num)
{
    for (int i = 0; i < pending_acks_count; i++)
    {
        if (pending_acks[i].seq_num == seq_num)
        {
            memmove(&pending_acks[i], &pending_acks[i + 1], (pending_acks_count - i - 1) * sizeof(PendingACK));
            pending_acks_count--;
            break;
        }
    }
}

void send_data(int sockfd, const char *data, struct sockaddr_in *client)
{
    int total_length = strlen(data);
    int total_chunks = (total_length + MAX_CHUNK_SIZE - 2) / (MAX_CHUNK_SIZE - 1);
    data_chunk chunk;
    int flags = fcntl(sockfd, F_GETFL, 0);
    fcntl(sockfd, F_SETFL, flags | O_NONBLOCK);

    for (long long int seq = 0; seq < total_chunks; seq++)
    {
        chunk.seq_num = seq;
        int chunk_size = (seq == total_chunks - 1) ? (total_length - seq * (MAX_CHUNK_SIZE - 1)) : (MAX_CHUNK_SIZE - 1);
        strncpy(chunk.data, data + seq * (MAX_CHUNK_SIZE - 1), chunk_size);
        chunk.data[chunk_size] = '\0';
        chunk.total_chunks = total_chunks;
        sendto(sockfd, &chunk, sizeof(chunk), 0, (struct sockaddr *)client, sizeof(*client));
        addAck(seq);

        char ack[256];
        int ack_len = recvfrom(sockfd, ack, sizeof(ack), 0, NULL, NULL);
        if (ack_len > 0)
        {
            long long int ack_seq = atoll(ack);
            printf("Received ACK for chunk %lld\n", ack_seq);
            removeAck(ack_seq);
        }

        double current_time = whatsTheTime();
        for (int i = 0; i < pending_acks_count; i++)
        {
            double sent_time = pending_acks[i].sent_time.tv_sec + (pending_acks[i].sent_time.tv_usec / 1000000.0);
            if (current_time - sent_time > TIMEOUT)
            {
                printf("Resending chunk %lld\n", pending_acks[i].seq_num);
                data_chunk resend_chunk;
                resend_chunk.seq_num = pending_acks[i].seq_num;
                resend_chunk.total_chunks = total_chunks;
                int resend_chunk_size = (resend_chunk.seq_num == total_chunks - 1) ? (total_length - resend_chunk.seq_num * (MAX_CHUNK_SIZE - 1)) : (MAX_CHUNK_SIZE - 1);
                strncpy(resend_chunk.data, data + resend_chunk.seq_num * (MAX_CHUNK_SIZE - 1), resend_chunk_size);
                resend_chunk.data[resend_chunk_size] = '\0';
                sendto(sockfd, &resend_chunk, sizeof(resend_chunk), 0, (struct sockaddr *)client, sizeof(*client));
                gettimeofday(&pending_acks[i].sent_time, NULL);
            }
        }
    }

    while (pending_acks_count > 0)
    {
        char ack[256];
        int ack_len = recvfrom(sockfd, ack, sizeof(ack), 0, NULL, NULL);
        if (ack_len > 0)
        {
            long long int ack_seq = atoll(ack);
            printf("Received ACK for chunk %lld\n", ack_seq);
            removeAck(ack_seq);
        }
        else if (errno != EAGAIN && errno != EWOULDBLOCK)
        {
            perror("recvfrom error");
            break;
        }
        else
        {
            double current_time = whatsTheTime();
            for (int i = 0; i < pending_acks_count; i++)
            {
                double sent_time = pending_acks[i].sent_time.tv_sec + (pending_acks[i].sent_time.tv_usec / 1000000.0);
                if (current_time - sent_time > TIMEOUT)
                {
                    printf("Resending chunk %lld\n", pending_acks[i].seq_num);
                    data_chunk resend_chunk;
                    resend_chunk.seq_num = pending_acks[i].seq_num;
                    resend_chunk.total_chunks = total_chunks;
                    int resend_chunk_size = (resend_chunk.seq_num == total_chunks - 1) ? (total_length - resend_chunk.seq_num * (MAX_CHUNK_SIZE - 1)) : (MAX_CHUNK_SIZE - 1);
                    strncpy(resend_chunk.data, data + resend_chunk.seq_num * (MAX_CHUNK_SIZE - 1), resend_chunk_size);
                    resend_chunk.data[resend_chunk_size] = '\0';
                    sendto(sockfd, &resend_chunk, sizeof(resend_chunk), 0, (struct sockaddr *)client, sizeof(*client));
                    gettimeofday(&pending_acks[i].sent_time, NULL);
                }
            }
        }
    }
}

int main(int argc, char *argv[])
{
    bool flag_connect = false;
    if (argc < 2)
    {
        flag_connect = true;
        // fprintf(stderr, "Usage: %s <port>\n", argv[0]);
        // exit(1);
    }

    int server_fd;
    struct sockaddr_in client, server_addr;

    // Create socket
    if ((server_fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Configure server address
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    if (flag_connect)
    {
        server_addr.sin_port = htons(8080);
    }
    else
    {
        server_addr.sin_port = htons(atoi(argv[1]));
    }

    // Bind socket
    if (bind(server_fd, (const struct sockaddr *)&server_addr, sizeof(server_addr)) < 0)
    {
        perror("bind failed");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    printf("Server is listening on port %s\n", argv[1]);

    char buffer[MAX_DATA_SIZE];
    initBuffer(&received_buffer, CIRCULAR_BUFFER_SIZE);

    // Receive first message to identify client
    socklen_t client_len = sizeof(client);
    int n = recvfrom(server_fd, buffer, sizeof(buffer) - 1, 0, (struct sockaddr *)&client, &client_len);
    if (n < 0 && strncmp(buffer, "connect", 7) != 0)
    {
        perror("recvfrom failed");
        close(server_fd);
        exit(EXIT_FAILURE);
    }
    buffer[n] = '\0';
    buffer[0] = '\0';

    while (true)
    {
        printf("Enter data to send to Client: ");
        if (fgets(buffer, sizeof(buffer), stdin) == NULL)
        {
            break;
        }
        buffer[strcspn(buffer, "\n")] = 0;

        send_data(server_fd, buffer, &client);

        data_chunk chunk;
        chunk.seq_num = -1;
        sendto(server_fd, &chunk, sizeof(chunk), 0, (struct sockaddr *)&client, sizeof(client));

        clearBuffer(&received_buffer);
        int expected_seq = 0;
        int total_chunks = -1;

        while (true)
        {
            n = recvfrom(server_fd, &chunk, sizeof(chunk), 0, (struct sockaddr *)&client, &client_len);
            if (n < 0)
            {
                if (errno != EAGAIN && errno != EWOULDBLOCK)
                {
                    perror("recvfrom failed");
                }
                continue;
            }
            if (chunk.seq_num == -1)
            {
                break;
            }

            if (total_chunks == -1)
            {
                total_chunks = chunk.total_chunks;
            }

            if (chunk.seq_num == expected_seq)
            {
                addtoBuffer(&received_buffer, chunk.data, strlen(chunk.data));
                expected_seq++;

                char ack[256];
                sprintf(ack, "%lld", chunk.seq_num);
                sendto(server_fd, ack, strlen(ack) + 1, 0, (struct sockaddr *)&client, sizeof(client));
            }

            if (expected_seq == total_chunks)
            {
                break;
            }
        }

        printf("Received Data:\n");
        for (int i = 0; i < received_buffer.size; i++)
        {
            putchar(received_buffer.data[(received_buffer.head + i) % received_buffer.capacity]);
        }
        printf("\n");
    }

    free(received_buffer.data);
    close(server_fd);
    return 0;
}