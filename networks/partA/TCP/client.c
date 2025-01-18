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
#define GREEN "\033[32m"
#define YELLOW "\033[33m"
#define BLUE "\033[34m"
#define MAGENTA "\033[35m"
#define CYAN "\033[36m"
#define WHITE "\033[37m"

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
    int sock = 0;
    struct sockaddr_in serv_addr;
    char buffer[MAX] = {0};

    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf(RED "\n Socket creation error \n" RESET);
        return -1;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
        printf(RED "\nInvalid address/ Address not supported \n" RESET);
        return -1;
    }

    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        printf(RED "\nConnection Failed \n" RESET);
        return -1;
    }

    while (1) {
        memset(buffer, 0, MAX);
        if (read(sock, buffer, MAX) <= 0) {
            printf(RED "Server disconnected. Exiting...\n" RESET);
            break;
        }
        if (strcmp(buffer, "Your turn") == 0) {
            int row, col;
            while (1) {
                printf(YELLOW "Enter your move (row and column): " RESET);
                scanf("%d %d", &row, &col);
                memset(buffer, 0, MAX);
                sprintf(buffer, "%d %d", row, col);
                send(sock, buffer, strlen(buffer), 0);
                memset(buffer, 0, MAX);
                read(sock, buffer, MAX);

                if (strncmp(buffer, "Invalid move", 12) == 0) {
                    printf(RED "Invalid move, try again.\n" RESET);
                } else {
                    printBoard(buffer);
                    break;
                }
            }
        } else if (strstr(buffer, "Wins") || strstr(buffer, "Draw")) {
            printf(GREEN "%s\n" RESET, buffer);
            // Ask if the player wants to play again
            while (1) {
                printf(YELLOW "Play again? (yes/no): " RESET);
                char response[MAX];
                scanf("%s", response);
                send(sock, response, strlen(response), 0);
                if (strncmp(response, "yes", 3) == 0 || strncmp(response, "no", 2) == 0) {
                    break;
                } else {
                    printf(RED "Invalid response. Please enter 'yes' or 'no'.\n" RESET);
                }
            }
        } else if (strncmp(buffer, "Opponent disconnected. You win by default.", 42) == 0) {            
            printf(RED "%s\n" RESET, buffer);
            break;
        } else if (strncmp(buffer, "Both players chose to exit. Closing connection.", 47) == 0 ||
                   strncmp(buffer, "Opponent chose to exit. Closing connection.", 42) == 0 ||
                   strncmp(buffer, "You chose to exit. Closing connection.", 37) == 0) {
            printf(RED "%s\n" RESET, buffer);
            break;
        } else {
            printBoard(buffer);
        }
    }

    close(sock);
    return 0;
}