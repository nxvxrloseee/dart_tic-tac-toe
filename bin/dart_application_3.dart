import 'dart:io';
import 'dart:math';

void main() {
  bool playAgain = true;

  while (playAgain) {
    print("Добро пожаловать в игру Крестики-нолики!");
    print("Выберите режим игры:");
    print("1. Играть против друга");
    print("2. Играть против робота");
    int mode = int.parse(stdin.readLineSync()!);

    print("Введите размер игрового поля (например, 3 для 3x3):");
    int size = int.parse(stdin.readLineSync()!);

    List<List<String>> board = List.generate(size, (_) => List.filled(size, ' '));
    bool isPlayerX = Random().nextBool();
    bool isGameOver = false;
    String currentPlayer = isPlayerX ? 'X' : 'O';
    bool isAgainstRobot = mode == 2;

    while (!isGameOver) {
      printBoard(board);
      print("Ход игрока $currentPlayer");

      if (isAgainstRobot && currentPlayer == 'O') {
        makeRobotMove(board);
      } else {
        makePlayerMove(board, currentPlayer);
      }

      if (checkWin(board, currentPlayer)) {
        printBoard(board);
        print("Игрок $currentPlayer выиграл!");
        isGameOver = true;
      } else if (isBoardFull(board)) {
        printBoard(board);
        print("Ничья!");
        isGameOver = true;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    }

    print("Хотите сыграть еще раз? (y/n)");
    String? response = stdin.readLineSync();
    playAgain = response?.toLowerCase() == 'y';
  }
}

void printBoard(List<List<String>> board) {
  for (int i = 0; i < board.length; i++) {
    print(board[i].join(' | '));
    if (i < board.length - 1) {
      print('-' * (board[i].length * 3 - 1));
    }
  }
}

void makePlayerMove(List<List<String>> board, String player) {
  while (true) {
    print("Введите строку и столбец (например, 1 2):");
    List<String> input = stdin.readLineSync()!.split(' ');
    int row = int.parse(input[0]) - 1;
    int col = int.parse(input[1]) - 1;

    if (row >= 0 && row < board.length && col >= 0 && col < board.length && board[row][col] == ' ') {
      board[row][col] = player;
      break;
    } else {
      print("Некорректный ход. Попробуйте снова.");
    }
  }
}

void makeRobotMove(List<List<String>> board) {
  Random random = Random();
  while (true) {
    int row = random.nextInt(board.length);
    int col = random.nextInt(board.length);

    if (board[row][col] == ' ') {
      board[row][col] = 'O';
      break;
    }
  }
}

bool checkWin(List<List<String>> board, String player) {
  // Проверка строк и столбцов
  for (int i = 0; i < board.length; i++) {
    if (board[i].every((cell) => cell == player)) return true;
    if (board.every((row) => row[i] == player)) return true;
  }

  // Проверка диагоналей
  if (board.every((row) => row[board.indexOf(row)] == player)) return true;
  if (board.every((row) => row[board.length - 1 - board.indexOf(row)] == player)) return true;

  return false;
}

bool isBoardFull(List<List<String>> board) {
  return board.every((row) => row.every((cell) => cell != ' '));
}