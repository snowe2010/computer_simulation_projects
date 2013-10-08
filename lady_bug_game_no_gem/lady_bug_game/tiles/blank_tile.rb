class BlankTile < GameBoard
  attr_reader :name, :text

  def initialize(*args)
    @name = "Blank"
    @text = "blank tile"  
  end
  
  def run
    true
  end
end
