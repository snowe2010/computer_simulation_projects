class GoBackTile
  attr_reader :value, :text, :name
  @gameboard
  
  def initialize value, gameboard
    @name = "Go Back #{value}"
    @value = value
    @text = "Go Back #{value} Spaces"
    @gameboard = gameboard
  end

  def run
    @gameboard.go_back @value
  end
end
