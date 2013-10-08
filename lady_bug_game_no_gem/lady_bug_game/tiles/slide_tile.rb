class SlideTile < Tile
  attr_reader :text, :name, :gameboard

  def initialize gameboard
    @name = "SlideTile"
    @text = "Slide across the branch"  
    @gameboard = gameboard
  end

  def run
    @gameboard.current_space = 13
  end
  
end
