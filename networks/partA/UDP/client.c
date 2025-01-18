#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080
#define MAX 1024

// ANSI color codes
#define RESET "\033[0m"
#define RED "\033[31m"
#define BLUE "\033[34m"
#define YELLOW "\033[33m"

void printBoard(char *board) {
    printf("\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            char cell = board[i * 3 + j];
            if (cell == 'X') {
                printf(RED " %c " RESET, cell);
            } else if (cell == 'O') {
                printf(BLUE " %c " RESET, cell);
            } else {
                printf(" %c ", cell);
            }
            if (j < 2) printf("|");
        }
        printf("\n");
        if (i < 2) printf("-----------\n");
    }
    printf("\n");
}

int main() {
    int sockfd;
    struct sockaddr_in serv_addr;
    socklen_t serv_len = sizeof(serv_addr);
    char buffer[MAX] = {0};

    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        printf(RED "\nSocket creation error\n" RESET);
        return -1;
    }

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
        printf(RED "\nInvalid address/ Address not supported\n" RESET);
        return -1;
    }

    // Notify the server of the client's presence (no data needed)
    sendto(sockfd, NULL, 0, 0, (const struct sockaddr *)&serv_addr, serv_len);

    while (1) {
        memset(buffer, 0, MAX);
        recvfrom(sockfd, buffer, MAX, 0, (struct sockaddr *)&serv_addr, &serv_len);

        if (strcmp(buffer, "Your turn") == 0) {
            int row, col;
            while (1) {
                printf(YELLOW "Enter your move (row and column): " RESET);
                scanf("%d %d", &row, &col);
                sprintf(buffer, "%d %d", row, col);
                sendto(sockfd, buffer, strlen(buffer), 0, (const struct sockaddr *)&serv_addr, serv_len);

                memset(buffer, 0, MAX);
                recvfrom(sockfd, buffer, MAX, 0, (struct sockaddr *)&serv_addr, &serv_len);

                if (strncmp(buffer, "Invalid move", 12) == 0) {
                    printf(RED "Invalid move, try again.\n" RESET);
                } else {
                    printBoard(buffer);
                    break;
                }
            }
        } else if (strstr(buffer, "Wins") || strstr(buffer, "Draw")) {
            printf(RED "%s\n" RESET, buffer);

            // Ask if the player wants to play again
            while (1) {
                printf(YELLOW "Play again? (yes/no): " RESET);
                char response[MAX];
                scanf("%s", response);
                sendto(sockfd, response, strlen(response), 0, (const struct sockaddr *)&serv_addr, serv_len);

                if (strncmp(response, "yes", 3) == 0 || strncmp(response, "no", 2) == 0) {
                    break;
                } else {
                    printf(RED "Invalid response. Please enter 'yes' or 'no'.\n" RESET);
                }
            }
        } else if (strncmp(buffer, "Opponent disconnected. You win by default.", 42) == 0 ||
                   strncmp(buffer, "Both players chose to exit. Closing connection.", 47) == 0 ||
                   strncmp(buffer, "Opponent chose to exit. Closing connection.", 42) == 0 ||
                   strncmp(buffer, "You chose to exit. Closing connection.", 37) == 0) {
            printf(RED "%s\n" RESET, buffer);
            break;
        } else {
            if(strncmp(buffer , "Play", 4) != 0){
                printBoard(buffer);
            }
        }
    }

    close(sockfd);
    return 0;
}
