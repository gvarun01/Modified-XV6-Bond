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
    memset(buffer->data, 0, capacity);
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

void clear_circular_buffer(CircularBuffer *buffer)
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

void send_data(int sockfd, char *data, struct sockaddr_in *client)
{
    int total_length = strlen(data);
    int total_chunks = (total_length + MAX_CHUNK_SIZE - 2) / (MAX_CHUNK_SIZE - 1);
    data_chunk chunk;
    int flags = fcntl(sockfd, F_GETFL, 0);
    fcntl(sockfd, F_SETFL, flags | O_NONBLOCK);

    for (long long int seq = 0; seq < total_chunks; seq++)
    {
        chunk.seq_num = seq;
        chunk.total_chunks = total_chunks;
        int chunk_size = (seq == total_chunks - 1) ? (total_length - seq * (MAX_CHUNK_SIZE - 1)) : (MAX_CHUNK_SIZE - 1);

        strncpy(chunk.data, data + seq * (MAX_CHUNK_SIZE - 1), chunk_size);
        chunk.data[chunk_size] = '\0';

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
    if (argc < 3)
    {
        flag_connect = true;
        // fprintf(stderr, "ERROR, no IP address or port provided\n");
        // exit(1);
    }

    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    data_chunk chunk;

    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }

    server_addr.sin_family = AF_INET;
    if (flag_connect == false)
    {
        server_addr.sin_port = htons(atoi(argv[2]));
        inet_pton(AF_INET, argv[1], &server_addr.sin_addr);
    }
    else
    {
        server_addr.sin_port = htons(8080);
        inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr);
    }

    char *message = "connect";
    sendto(sockfd, message, strlen(message), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));

    initBuffer(&received_buffer, CIRCULAR_BUFFER_SIZE);

    while (true)
    {
        // int flag = 0;

        while (true)
        {
            int n = recvfrom(sockfd, &chunk, sizeof(chunk), 0, (struct sockaddr *)&client_addr, &addr_len);
            if (n < 0)
            {
                if (errno == EAGAIN || errno == EWOULDBLOCK)
                {
                    // No data available, continue the loop
                    continue;
                }
                else
                {
                    // Handle other errors
                    perror("recvfrom error");
                    break;
                }
            }
            if (chunk.seq_num == -1)
            {
                break;
            }

            printf("Received chunk %lld: %s\n", chunk.seq_num, chunk.data);

            // if (flag)
            // {
                char ack[256];
                sprintf(ack, "%lld", chunk.seq_num);
                int rc = sendto(sockfd, ack, sizeof(ack), 0, (struct sockaddr *)&client_addr, addr_len);
                if(rc >= 0) {
                    addtoBuffer(&received_buffer, chunk.data, strlen(chunk.data));
                }
            //     flag = 0;
            // }
            // else
            // {
            //     flag = 1;
            // }
        }

        printf("Received Data in Order:\n");
        for (int i = 0; i < received_buffer.size; i++)
        {
            printf("%c", received_buffer.data[(received_buffer.head + i) % received_buffer.capacity]);
        }
        printf("\n");

        // Reset the circular buffer
        clear_circular_buffer(&received_buffer);

        printf("Enter data to send to Server: ");
        char input[2048]; // Increased size to accommodate null terminator
        if (fgets(input, sizeof(input), stdin) == NULL)
        {
            perror("Error reading input");
            continue;
        }
        input[strcspn(input, "\n")] = 0; // Remove newline if present

        send_data(sockfd, input, &server_addr);

        data_chunk chunk2;
        chunk2.seq_num = -1;
        sendto(sockfd, &chunk2, sizeof(chunk2), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
    }

    free(received_buffer.data);
    close(sockfd);
    return 0;
}