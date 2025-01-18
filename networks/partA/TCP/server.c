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
    // Check rows and columns
    for (int i = 0; i < 3; i++) {
        if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != ' ')
            return 1;
        if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != ' ')
            return 1;
    }
    // Check diagonals
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

void sendBoard(int client1, int client2) {
    char buffer[MAX];
    memset(buffer, 0, MAX);
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            buffer[i * 3 + j] = board[i][j];
        }
    }
    send(client1, buffer, sizeof(buffer), 0);
    send(client2, buffer, sizeof(buffer), 0);
}

void handleClient(int client1, int client2) {
    char buffer[MAX];
    int row, col;
    while (1) {
        memset(buffer, 0, MAX);
        int currentClient = (currentPlayer == 1) ? client1 : client2;
        int otherClient = (currentPlayer == 1) ? client2 : client1;
        send(currentClient, "Your turn", 9, 0);
        int bytesReceived = recv(currentClient, buffer, sizeof(buffer), 0);
        if (bytesReceived <= 0) {
            printf("Hmmmm. Something went wrong. Exiting...\n");
            send(otherClient, "Opponent disconnected. You win by default.", 42, 0);
            return;
        }
        sscanf(buffer, "%d %d", &row, &col);
        row -= 1;
        col -= 1;
        if (row < 0 || row > 2 || col < 0 || col > 2 || board[row][col] != ' ') {
            send(currentClient, "Invalid move", 12, 0);
            continue;
        }
        board[row][col] = (currentPlayer == 1) ? 'X' : 'O';
        
        if (checkWin()) {
            sendBoard(client1, client2);
            send(client1, (currentPlayer == 1) ? "Player 1 Wins!" : "Player 2 Wins!", 15, 0);
            send(client2, (currentPlayer == 1) ? "Player 1 Wins!" : "Player 2 Wins!", 15, 0);
            break;
        }
        if (checkDraw()) {
            sendBoard(client1, client2);
            send(client1, "It's a Draw!", 12, 0);
            send(client2, "It's a Draw!", 12, 0);
            break;
        }
        currentPlayer = (currentPlayer == 1) ? 2 : 1;
        sendBoard(client1, client2);
    }

    // Ask players if they want to play again
    send(client1, "Play again? (yes/no)", 19, 0);
    send(client2, "Play again? (yes/no)", 19, 0);

    char response1[MAX], response2[MAX];
    int bytesReceived1 = recv(client1, response1, sizeof(response1), 0);
    int bytesReceived2 = recv(client2, response2, sizeof(response2), 0);

    if (bytesReceived1 <= 0 || bytesReceived2 <= 0) {
        if (bytesReceived1 <= 0) {
            send(client2, "Opponent disconnected. Closing connection.", 42, 0);
        }
        if (bytesReceived2 <= 0) {
            send(client1, "Opponent disconnected. Closing connection.", 42, 0);
        }
    } else {
        if (strncmp(response1, "yes", 3) == 0 && strncmp(response2, "yes", 3) == 0) {
            initializeBoard();
            sendBoard(client1, client2);
            handleClient(client1, client2);
        } else if (strncmp(response1, "no", 2) == 0 && strncmp(response2, "no", 2) == 0) {
            send(client1, "Both players chose to exit. Closing connection.", 47, 0);
            send(client2, "Both players chose to exit. Closing connection.", 47, 0);
        } else if (strncmp(response1, "yes", 3) == 0 && strncmp(response2, "no", 2) == 0) {
            send(client1, "Opponent chose to exit. Closing connection.", 42, 0);
            send(client2, "You chose to exit. Closing connection.", 37, 0);
        } else if (strncmp(response1, "no", 2) == 0 && strncmp(response2, "yes", 3) == 0) {
            send(client1, "You chose to exit. Closing connection.", 37, 0);
            send(client2, "Opponent chose to exit. Closing connection.", 42, 0);
        }
    }
}

int main() {
    int server_fd, client1, client2;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    int opt = 1;

    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    // Set the SO_REUSEADDR option
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt))) {
        perror("setsockopt");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    if (listen(server_fd, 3) < 0) {
        perror("listen");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    printf("Waiting for players to connect...\n");

    if ((client1 = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
        perror("accept");
        close(server_fd);
        exit(EXIT_FAILURE);
    }
    printf("Player 1 connected\n");

    if ((client2 = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
        perror("accept");
        close(server_fd);
        exit(EXIT_FAILURE);
    }
    printf("Player 2 connected\n");

    initializeBoard();
    sendBoard(client1, client2);
    handleClient(client1, client2);

    close(client1);
    close(client2);
    close(server_fd);
    return 0;
}