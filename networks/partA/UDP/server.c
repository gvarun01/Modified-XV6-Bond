#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080
#define MAX 1024

char board[3][3];
int currentPlayer = 1;

void initializeBoard() {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            board[i][j] = ' ';
        }
    }
}

void printBoard() {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%c", board[i][j]);
            if (j < 2) printf("|");
        }
        printf("\n");
        if (i < 2) printf("-----\n");
    }
}

int checkWin() {
    for (int i = 0; i < 3; i++) {
        if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != ' ')
            return 1;
        if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != ' ')
            return 1;
    }
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != ' ')
        return 1;
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != ' ')
        return 1;
    return 0;
}

int checkDraw() {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (board[i][j] == ' ')
                return 0;
        }
    }
    return 1;
}

void sendBoard(int sockfd, struct sockaddr_in *client1_addr, struct sockaddr_in *client2_addr, socklen_t addr_len) {
    char buffer[MAX];
    memset(buffer, 0, MAX);
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            buffer[i * 3 + j] = board[i][j];
        }
    }
    sendto(sockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)client1_addr, addr_len);
    sendto(sockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)client2_addr, addr_len);
}

void handleClient(int sockfd, struct sockaddr_in *client1_addr, struct sockaddr_in *client2_addr, socklen_t addr_len) {
    char buffer[MAX];
    int row, col;

    while (1) {
        memset(buffer, 0, MAX);
        struct sockaddr_in *currentClient = (currentPlayer == 1) ? client1_addr : client2_addr;
        struct sockaddr_in *otherClient = (currentPlayer == 1) ? client2_addr : client1_addr;

        sendto(sockfd, "Your turn", 9, 0, (struct sockaddr *)currentClient, addr_len);
        recvfrom(sockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)currentClient, &addr_len);
        sscanf(buffer, "%d %d", &row, &col);

        row -= 1;
        col -= 1;
        if (row < 0 || row > 2 || col < 0 || col > 2 || board[row][col] != ' ') {
            sendto(sockfd, "Invalid move", 12, 0, (struct sockaddr *)currentClient, addr_len);
            continue;
        }

        board[row][col] = (currentPlayer == 1) ? 'X' : 'O';

        if (checkWin()) {
            sendBoard(sockfd, client1_addr, client2_addr, addr_len);
            sendto(sockfd, (currentPlayer == 1) ? "Player 1 Wins!" : "Player 2 Wins!", 15, 0, (struct sockaddr *)client1_addr, addr_len);
            sendto(sockfd, (currentPlayer == 1) ? "Player 1 Wins!" : "Player 2 Wins!", 15, 0, (struct sockaddr *)client2_addr, addr_len);
            break;
        }

        if (checkDraw()) {
            sendBoard(sockfd, client1_addr, client2_addr, addr_len);
            sendto(sockfd, "It's a Draw!", 12, 0, (struct sockaddr *)client1_addr, addr_len);
            sendto(sockfd, "It's a Draw!", 12, 0, (struct sockaddr *)client2_addr, addr_len);
            break;
        }

        currentPlayer = (currentPlayer == 1) ? 2 : 1;
        sendBoard(sockfd, client1_addr, client2_addr, addr_len);
    }

    // Rematch logic
    sendto(sockfd, "Play again? (yes/no)", 19, 0, (struct sockaddr *)client1_addr, addr_len);
    sendto(sockfd, "Play again? (yes/no)", 19, 0, (struct sockaddr *)client2_addr, addr_len);

    char response1[MAX], response2[MAX];
    recvfrom(sockfd, response1, sizeof(response1), 0, (struct sockaddr *)client1_addr, &addr_len);
    recvfrom(sockfd, response2, sizeof(response2), 0, (struct sockaddr *)client2_addr, &addr_len);

    if (strncmp(response1, "yes", 3) == 0 && strncmp(response2, "yes", 3) == 0) {
        initializeBoard();
        sendBoard(sockfd, client1_addr, client2_addr, addr_len);
        handleClient(sockfd, client1_addr, client2_addr, addr_len);
    } else if (strncmp(response1, "no", 2) == 0 && strncmp(response2, "no", 2) == 0) {
        sendto(sockfd, "Both players chose to exit. Closing connection.", 47, 0, (struct sockaddr *)client1_addr, addr_len);
        sendto(sockfd, "Both players chose to exit. Closing connection.", 47, 0, (struct sockaddr *)client2_addr, addr_len);
    } else if (strncmp(response1, "yes", 3) == 0 && strncmp(response2, "no", 2) == 0) {
        sendto(sockfd, "Opponent chose to exit. Closing connection.", 42, 0, (struct sockaddr *)client1_addr, addr_len);
        sendto(sockfd, "You chose to exit. Closing connection.", 37, 0, (struct sockaddr *)client2_addr, addr_len);
    } else if (strncmp(response1, "no", 2) == 0 && strncmp(response2, "yes", 3) == 0) {
        sendto(sockfd, "You chose to exit. Closing connection.", 37, 0, (struct sockaddr *)client1_addr, addr_len);
        sendto(sockfd, "Opponent chose to exit. Closing connection.", 42, 0, (struct sockaddr *)client2_addr, addr_len);
    }
}

int main() {
    int sockfd;
    struct sockaddr_in serv_addr, client1_addr, client2_addr;
    socklen_t addr_len = sizeof(serv_addr);

    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(PORT);

    if (bind(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("bind failed");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Waiting for Player 1 to connect...\n");
    recvfrom(sockfd, NULL, 0, 0, (struct sockaddr *)&client1_addr, &addr_len);
    printf("Player 1 connected\n");

    printf("Waiting for Player 2 to connect...\n");
    recvfrom(sockfd, NULL, 0, 0, (struct sockaddr *)&client2_addr, &addr_len);
    printf("Player 2 connected\n");

    initializeBoard();
    sendBoard(sockfd, &client1_addr, &client2_addr, addr_len);
    handleClient(sockfd, &client1_addr, &client2_addr, addr_len);

    close(sockfd);
    return 0;
}
