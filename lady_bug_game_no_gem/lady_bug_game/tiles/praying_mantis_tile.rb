class PrayingMantisTile < StopTile
  attr_reader :text, :name, :gameboard

  def initialize gameboard
    @name = "PrayingMantisTile"
    @text = "Give the Mantis a Pass or Go Back to Start"  
    @gameboard = gameboard
  end
  
  def run
    if @gameboard.player.praying_mantis_passes > 0 
      @gameboard.player.praying_mantis_passes -= 1
    else
      @gameboard.current_space = 0
    end
  end
  
end
