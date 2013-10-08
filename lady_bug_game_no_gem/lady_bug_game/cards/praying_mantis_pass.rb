class PrayingMantisPass < Tile
  attr_reader :text, :name, :gameboard
  def initialize *args
    @text = "Praying Mantis Pass"
    @name = "PrayingMantisPass"
    @gameboard = args[0]
  end

  def go_again?
    false
  end

  def run
    @gameboard.player.praying_mantis_passes += 1
  end
end
