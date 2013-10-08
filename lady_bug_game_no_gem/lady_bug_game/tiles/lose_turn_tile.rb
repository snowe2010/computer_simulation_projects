class LoseTurnTile < Tile
  attr_reader :text, :name

  def initialize gameboard
    @name = "LoseTurnTile"
    @text = "Lose a Turn" 
    @gameboard = gameboard
  end

  def run
    @gameboard.player.lose_turn = true
  end
end
