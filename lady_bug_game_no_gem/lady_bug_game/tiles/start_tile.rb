class StartTile
  attr_reader :name, :text

  def initialize(*args)
    @name = "Start"
    @text = "Start tile"  
  end  

  def run
    true
  end
end
