from pathlib import Path


def parse_input():
    bingo_input = Path("input.txt").read_text()
    draw_sequence, boards = bingo_input.split("\n", 1)
    boards = boards.split("\n", 1)[1]
    boards = boards.split("\n\n")

    def parse_board(board):
        rows = board.split('\n')
        rows = list(map(lambda x: list(map(int, x.split())), rows))
        return rows

    boards = list(map(parse_board, boards))

    draw_sequence = draw_sequence.split(',')
    draw_sequence = list(map(int, draw_sequence))

    return draw_sequence, boards


def is_board_winner(board):
    for row in board:
        all_row_null = True
        for el in row:
            if el != None:
                all_row_null = False
        if all_row_null:
            return all_row_null

    for i in range(len(board[0])):
        all_col_null = True
        for row in board:
            if row[i] != None:
                all_col_null = False
        if all_col_null:
            return all_col_null

    return False


def mark_board(board, number):
    for row in board:
        for i, el in enumerate(row):
            if el == number:
                row[i] = None


def get_board_score(board, last_number):
    sum = 0
    for row in board:
        for number in row:
            if number:
                sum += number

    return sum * last_number


def play_bingo(draw_sequence, boards):
    for number in draw_sequence:
        for board in boards:
            mark_board(board, number)
            if is_board_winner(board):
                score = get_board_score(board, number)
                print(f"winner board score:{score}")
                return


def play_bingo_to_bitter_end(draw_sequence, boards):
    "returns the absolute failure"
    for number in draw_sequence:
        for board in boards:
            mark_board(board, number)
        for i, board in enumerate(boards):
            if is_board_winner(board):
                score = get_board_score(board, number)
                print(f"winner board score:{score}")

                del boards[i]
                if len(boards) == 0:
                    return


draw_sequence, boards = parse_input()
# play_bingo(draw_sequence, boards)
play_bingo_to_bitter_end(draw_sequence, boards)
