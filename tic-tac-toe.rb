# TIC TAC TOE
#
# PSEUDO: I set up a 3x3 matrix filled with whitespace chars. Then I ask players for coordinates
#         where they want to place their choice. I use class 'Game' where I initialize the matrix.
#         Then I use instance method 'play_round' where I ask for input and then I call from within
#         the play_round method another method called 'matrix_update' which updates the matrix
#         accordingly. I make another method which will check if there is a winner and this method
#         will use 3 more methods to check rows, columns and diagonals.
#
# RESULT: It's pretty mess but it's my first bigger ruby project so I didn't expect much more from it.
#         There are still few issues I could have taken care of like 'draw' or multiple characters input
#         but those are just minor problems and it would be waste of time at this moment.

class Game  # class Game
  @@coor1 # desired coordinations
  @@coor2

  # this variable will store the winner and will be checked from outside of class
  def winner; @@winner; end

  def pass; end # to do nothing in conditions

  def initialize
    @matrix = Array.new(3) { Array.new(3, ' ')} # creates 3x3 array with whitespace inside
    @player1 = 0  # player's turns counter
    @player2 = 0
    @@winner = 0
  end

  def play_round
    puts "\n#{@matrix[0]}\n#{@matrix[1]}\n#{@matrix[2]}\n\n"  # display matrix in the beginning of every turn
    if @player1 == @player2 # condition for changing turns between player1 and player2
      puts "It's player1's turn. Insert your coordinates:\n"
      @@coor1 = gets.chomp.to_i # get desired coordinations
      @@coor2 = gets.chomp.to_i
      matrix_update # call for update of matrix
      @player1 += 1
    else
      puts "It's player2's turn. Insert your coordinates:\n"
      @@coor1 = gets.chomp.to_i
      @@coor2 = gets.chomp.to_i
      matrix_update
      @player2 += 1
    end
  end

  def matrix_update
    if [0, 1, 2].include?(@@coor1) == false || [0, 1, 2].include?(@@coor2) == false # coors <0,2>
      puts 'Coordinates are from 0 to 2!'
      @player1 == @player2 ? @player1 -= 1 : @player2 -= 1 # this secure that player goes again

    elsif @matrix[@@coor1][@@coor2] == ' ' && @player1 == @player2  
      @matrix[@@coor1][@@coor2] = 'X' # set 'X' to matrix
      winner?('player1') # check if there is a winner
      @@winner == 0 ? pass : (puts "\n#{@matrix[0]}\n#{@matrix[1]}\n#{@matrix[2]}\n\n")

    elsif @matrix[@@coor1][@@coor2] == ' ' && @player1 > @player2
      @matrix[@@coor1][@@coor2] = 'O' # set 'O' to matrix
      winner?('player2') # check if there is a winner
      @@winner == 0 ? pass : (puts "\n#{@matrix[0]}\n#{@matrix[1]}\n#{@matrix[2]}\n\n")
    else
      puts 'Already chosen!' # can't change alredy occupied coordinations
      @player1 == @player2 ? @player1 -= 1 : @player2 -= 1
    end
  end

  def winner?(player) # checks for winner
    case player
    when 'player1'
      check_rows('X') || check_columns('X') || check_diagonals('X') ? @@winner = 1 : pass = 0
    when 'player2'
      check_rows('O') || check_columns('O') || check_diagonals('O') ? @@winner = 2 : pass = 0
    end
  end

  def check_rows(char)  # checks rows
    win = false
    [0, 1, 2].each do |i|
      if @matrix[i].count(char) == 3
        win = true
      end
    end
    win
  end

  def check_columns(char) # checks columns
    win = false
    [0, 1, 2].each do |i|
      count = 0
      [0, 1, 2].each do |j|
        if @matrix[j][i] == char
          count += 1
        end
      end
      count == 3 ? win = true : pass
    end
    win
  end

  def check_diagonals(char) # checks diagonals
    win = false
    count1 = 0
    count2 = 0
    [0, 1, 2].each do |i|
      if @matrix[i][i] == char
        count1 += 1
      end
      if @matrix[i][2-i] == char
        count2 += 1
      end
    end
    (count1 == 3 || count2 == 3) ? win = true : pass
    win
  end
end

x = 0 # program ends only if player refuses to continue
games = 0

until x == 'N' || x == 'n'
  puts "WELCOME\n  Choose 'X' or 'O' by typing down the coordinates" 
  game = Game.new # game initialization

  while game.winner == 0  # plays until there is a winner
    game.play_round
  end

  puts game.winner == 1 ? "Player1 has won!" : "Player2 has won!"
  puts "Do you want to play again? (Y/N)"
  x = gets.chomp
  unless x == 'y' || x == 'Y' || x == 'n' || x == 'N'
    puts "I take that as yes"
  end
end
