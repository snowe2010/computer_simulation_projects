class AntTile < StopTile
  attr_reader :text, :name

  def initialize gameboard
    @name = "AntTile"
    @text = "Give the ants 10 aphids or go back this way"  
    @gameboard = gameboard
  end

  def run
    if @gameboard.player.aphid_chips >= 10
      @gameboard.player.aphid_chips -= 10
      @gameboard.current_space = 26
    else 
      @gameboard.main_board = @gameboard.loop
      @gameboard.current_space = 0
    end
  end
end
