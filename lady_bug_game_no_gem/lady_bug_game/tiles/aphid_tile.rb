class AphidTile < Tile
  attr_reader :text, :name, :value

  def initialize value, gameboard
    @name = "AphidTile"
    @value = value
    @text = "You get #{value} aphids"  
    @gameboard = gameboard
  end

  def run
    @gameboard.player.aphid_chips += @value
  end

end
