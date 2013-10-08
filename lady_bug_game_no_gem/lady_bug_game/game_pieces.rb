class GamePieces
  attr_accessor :bucket
  def initialize file
    @bucket = []
    pieces = YAML.load_file(file)
    pieces.each do |class_name, number_of_pieces|
      number_of_pieces.times {@bucket << Object::const_get(class_name).new}
    end
  end
end
