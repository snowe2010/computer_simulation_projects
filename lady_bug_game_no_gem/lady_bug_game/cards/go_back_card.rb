class GoBackCard < Tile
  
  attr_reader :card_type, :card_value, :text

  def initialize card_type, card_value
    @card_type = card_type
    @card_value = card_value
    @text = "Go Back #{card_value} Spaces"
    
    if card_type == :go_again 
      @text << " and Go Again" 
      @go_again = true
    end
  end

  def go_again?
    @go_again
  end
end
