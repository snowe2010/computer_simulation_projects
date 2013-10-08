class HomeTile < GameBoard
  attr_reader :name, :text

  def initialize gameboard
    @name = "Home"
    @text = "Home tile"  
    @gameboard = gameboard
  end

  def run
    @gameboard.player.winner = true
  end
end
