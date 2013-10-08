class Player
  attr_accessor :aphid_chips, :praying_mantis_passes, :current_player, :current_card, :game_board, :lady_bug_class, :winner, :lose_turn
  attr_reader :turns

  def initialize lady_bug_class, index
    @aphid_chips, @praying_mantis_passes = 0,0
    @game_board = GameBoard.new self
    @lady_bug_class = lady_bug_class
    @name = "Player #{index}"
    @winner = false
    @lose_turn = false
    @turns = 0
  end

  def evaluate_card card
    @turns += 1
    @current_card = card

    case @current_card
      when MoveAheadCard
        @game_board.move_ahead @current_card.card_value
        evaluate_tile
      when GoBackCard
        @game_board.go_back @current_card.card_value
        evaluate_tile
      when PrayingMantisPass
        @praying_mantis_passes += 1
      when AphidCard
        @aphid_chips += @current_card.card_value
      end

    board = "board"
    if @game_board.main_board == @game_board.loop
      board = "loop"
  end

    @lady_bug_class.current_player_go_again= true if @current_card.go_again?
    # puts "Current space: #{@game_board.current_space}\t|\tCurrent tile: #{@game_board.main_board[@game_board.current_space].text}\t|\tCurrent # of Aphids: #{@aphid_chips}"
    # puts "Go again?: #{@lady_bug_class.current_player_go_again} \t|\tPlayer name: #{@name} \t\t|\tCurrent # of PM Passes: #{@praying_mantis_passes} \t\t|\tCurrent Board: #{board}\n\n"

    if(@winner)
      @lady_bug_class.winner = true
    end
  end

  def evaluate_tile 
    # puts "gameboard: #{@game_board.main_board[@game_board.current_space]}"
    # puts "You landed on the #{@game_board.main_board[@game_board.current_space].name} tile"
    if @game_board.main_board[@game_board.current_space].nil?
      puts @game_board.current_space.inspect
      puts @game_board.main_board.size
      puts @game_board.main_board[@game_board.current_space].inspect
    end
    @game_board.main_board[@game_board.current_space].run
  end
end
