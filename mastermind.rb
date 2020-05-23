# MASTERMIND
#
# PSEUDO: I ask user if he/she wants to play as CodeMaker or CodeBreaker. Then I fill the array(code)
#         accordingly - by user's input for CodeMaker, randomly for CodeBreaker. I create feedback array
#         where the codemaker's feedback will be automaticly generated - eventually I ended up doing
#         it all in one 2D array as I will mention later. Now I have to create 2D array
#         which will be the size Nx4 (Nx8 with feedback) according to what N(number of rounds) player
#         chooses. Then I add method for generating feedback and finally make logic that will be applied
#         when computer guesses the code.
#
# RESULT: I made the simplest mastermind game possible in order to utilize my time the best way. Even 
#         this simple solution has taken many hours of work. It's time to move on and I can always 
#         come back. I use only X's and O's so computer is able to guess the right code in max 6 rounds.
#         Some parts of the code are really unreadable. Also division into classes, methods
#         and modules could be way better.

module Game

  attr_reader :winner

  def winner; @winner; end  # read @winner from main code

  def create_board(n) # first 4 will be for player input 1 space and last 4 will be feedback
    @board = Array.new(n) { Array.new(9, ' ')}
    @board.each do |e|
      p e
    end
  end

  def set_feedback  # one '@' for each exact match and one '#' for each other 'color' match
    feedback = Array.new(4, '0')
    arrayX = 0
    boardX = 0
    arrayO = 0
    boardO = 0
    for i in 0..3 do
      feedback[i] = @array[i] == @board[@round_count - 1][i] ? '@' : '0'
      unless feedback[i] == '@'
        if @array[i] == 'X'
          arrayX += 1
        end
        if @board[@round_count - 1][i] == 'X'
          boardX += 1
        end
        if @array[i] == 'O'
          arrayO += 1
        end
        if @board[@round_count - 1][i] == 'O'
          boardO += 1
        end
      end
    end
    hash_count = 0
    hash_count += boardX > arrayX ? arrayX : boardX  # hash_count is number of hashes that feedback
    hash_count += boardO > arrayO ? arrayO : boardO # should contain

    while hash_count > 0
        feedback[feedback.index('0')] = '#'
        hash_count -= 1
    end
    @feedback = feedback.shuffle
    if @feedback == %w(@ @ @ @)
      @winner = 1
    end
  end
end

class GameAsCodeBreaker
  include Game

  def initialize(array)
    @array = array
  end

  def play_round(guess, round_count)
    @guess = guess
    @round_count = round_count
    for i in 0..3 do
      @board[@round_count - 1][i] = @guess[i]
    end
    set_feedback
    for i in 5..8 do
      @board[@round_count - 1][i] = @feedback[i - 5]
    end
    @board.each do |e|
      p e
    end
  end
end

class GameAsCodeMaker
  include Game

  def initialize(array)
    p @array = array
  end

  @guess = Array.new(4)

  def play_round(round_count)
    @round_count = round_count
    if @round_count == 1  # first round computer try all 'X's
      @guess = %w(X X X X)
    else
      case @board[0].count('@')
      when 0  # no @ in feedback[0]
        @guess = %w(O O O O)
      when 1  # 1 @ in feedback[0]
        @guess = %w(O O O O)
        @guess[round_count - 2] = 'X'
      when 2  # 2 @ in feedback[0]
        case round_count
        when 2
          @guess = %w(X O O O)
        when 3
          if @feedback.count('@') == 1
            @guess = %w(O X O O)
          else
            @guess = %w(X X O O)
          end
        when 4
          if @feedback.count('@') == 1
            @guess = %w(O O X X)
          elsif @board[2].count('@') == 2
            @guess = %w(X O X O)
          else
            @guess = %w(O X X O)
          end
        when 5
          if @board[3].count('@') == 2 && @board[3][5] == 'O'
            @guess = %w(O X O X)
          else
            @guess = %w(X O O X)
          end
        else
          @guess = %w(O X O X)
        end
      when 3  # 3 @ in feedback[0]
        @guess = %w(X X X X)
        @guess[round_count - 2] = 'O'
      end
    end

    for i in 0..3
      @board[@round_count - 1][i] = @guess[i] # set computer's guess onto board
    end
    set_feedback  # call for feedback
    for i in 5..8 do  # this sets feedback onto board +5 next lines
      @board[@round_count - 1][i] = @feedback[i - 5]
    end
    @board.each do |e|
      p e
    end
  end
end

class RandomFill  # fills array(code) randomly
  def initialize(array)
    @array = array
  end

  def fill  # method for random filling the array(code) with 'X's / 'O's respectively
    @array = @array.map do |e|
      e = rand 2
    end
    @array = @array.map do |e|
      e = (e == 0) ? 'X' : 'O'
    end
  end
end

class ManualFill  # fills array(code) manualy by user
  def initialize(array)
    @array = array
  end

  def fill  # method for manual filling the array(code) with 'X's / 'O's respectively 
    i = 1
    puts "Choose your code (X or O)\n"
    @array = @array.map do |e|
      print "\t#{i}:  "
      e = gets.chomp.upcase
      unless e == 'x' || e == 'X' || e == 'o' || e == 'O'
        puts "Wrong input. You have one more try otherwise it will be set as 'X'."
        print "\t#{i}:  "
        e = gets.chomp.upcase
        unless e == 'x' || e == 'X' || e == 'o' || e == 'O'
          e = 'X'
          print "\t#{i}:  X\n"
        end
      end
      i += 1
      e
    end
    @array
  end
end

array = Array.new(4)  # array in which will be the code stored - could be assigned in class but whatever
game_type = 0 # game as CodeMaker / CodeBreaker

puts "\n\tWELCOME\n\nType '1' for playing as CODEBREAKER or '2' for playing as CODEMAKER\n\n"
until game_type == 1 || game_type == 2
  game_type = gets.chomp.to_i
  if game_type == 1 # CodeBreaker has been chosen
    array = RandomFill.new(array).fill # class that fills array(code) randomly
    game = GameAsCodeBreaker.new(array)  # initialization
  elsif game_type == 2  # CodeMaker has been chosen
    array = ManualFill.new(array).fill # class that fills array(code) manualy
    game = GameAsCodeMaker.new(array) # initialization
  else
    puts "Wrong input. Try again:"
  end
end

puts "\nHow many rounds? (choose from 1 to 12, 6 is default)\n"
rounds = gets.chomp.to_i
unless rounds > 0 && rounds < 13
  rounds = 6
end

game.create_board(rounds) # creates board

round_count = 1
guess = Array.new(4)

# Game as a CodeBreaker
if game_type == 1
  while (game.winner == nil) && (round_count <= rounds)
    puts "\nRound #{round_count}"
    for i in 0..3 do
      puts "Type your #{i + 1}. guess ('X' or 'O')\n"
      guess[i] = gets.chomp.upcase
    end
    game.play_round(guess, round_count)
    round_count += 1
  end
else

# Game as a CodeMaker
  while (game.winner == nil) && (round_count <= rounds)
    puts "\nRound #{round_count}"
    game.play_round(round_count)
    round_count += 1
  end
end

if game.winner
  puts "\nThe Code Breaker has won the game in #{round_count - 1} rounds\n"
else
  puts "\nThe Code Maker has won the game in #{round_count - 1} rounds\n"
end
