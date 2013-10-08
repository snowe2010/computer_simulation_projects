class AphidCard
  attr_reader :card_value, :text
  def initialize card_value
    @card_value = card_value
    @text = "You get #{card_value} aphids!"
  end

  def go_again?
    false
  end
end
