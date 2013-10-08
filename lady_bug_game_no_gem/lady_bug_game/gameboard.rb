class GameBoard
  BOARD_CONFIGURATION_FILE = "lib/lady_bug_game/resources/game_board.yml"
  attr_reader :board, :loop, :player
  attr_accessor :current_space, :main_board

  def initialize player
    connector_1 = BlankTile.new
    connector_2 = AntTile.new(self)
    @board = [ StartTile.new, PrayingMantisPass.new(self), BlankTile.new, AphidTile.new(3, self), 
                    PrayingMantisPass.new(self), BlankTile.new, SlideTile.new(self), BlankTile.new, 
                    PrayingMantisPass.new(self), PrayingMantisTile.new(self), BlankTile.new, 
                    BlankTile.new, BlankTile.new, AphidTile.new(2, self), BlankTile.new, 
                    AphidTile.new(5, self), BlankTile.new, AphidTile.new(-2, self), BlankTile.new, 
                    BlankTile.new, GoBackTile.new(2, self), BlankTile.new, connector_1,
                    AphidTile.new(2, self), AphidTile.new(-1, self), AphidTile.new(2, self), connector_2,
                    BlankTile.new, LoseTurnTile.new(self), BlankTile.new, BlankTile.new, 
                    BlankTile.new, LoseTurnTile.new(self), BlankTile.new, HomeTile.new(self)]
    @loop       = [ connector_2, BlankTile.new, AphidTile.new(1, self), BlankTile.new, AphidTile.new(3, self), 
                    BlankTile.new, GoBackTile.new(2, self), BlankTile.new, connector_1]
    @main_board = @board
    @current_space = 0
    @player = player
  end

  def go_back spaces
    if @main_board == @board 
      @current_space -= spaces unless @current_space == 0
    elsif @main_board == @loop
      i = 0
      spaces.times do
        @current_space -= 1 
        if @current_space == 0
          @main_board = @board
          i += 1
        end
      end
      
      if @main_board == @board
        @current_space = 26 - i
      end
    end
  end

  def move_ahead spaces
    if @main_board == @board
      if (@main_board[@current_space+spaces].is_a? HomeTile)
        @player.winner = true
      end
      spaces.times do 
        if (@main_board[@current_space+1].is_a? StopTile)
          @current_space += 1 unless (@current_space + 1) >= @main_board.size
          @player.winner = false
          return 
        end
        @current_space += 1 unless (@current_space + 1) >= @main_board.size
      end
    elsif @main_board == @loop
        if @current_space+spaces >= @main_board.size-1
          index = spaces - (@main_board.size-1-@current_space) + 22
          @main_board = @board
          @current_space = index
        else
          @current_space += spaces
        end
    end
  end
end
