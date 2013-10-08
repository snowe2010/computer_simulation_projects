require 'yaml'

class Deck
  attr_accessor :deck, :backup_deck
  attr_reader :seed, :file

  def initialize file, seed
    @deck = []
    @backup_deck = []
    @seed = seed
    @file = file
  end

  def build
    cards = YAML.load_file(@file)

    ## Read through every line
    cards.each do |class_name, int_or_hash| 
      ## If that line contains a string: number then instantiate that class number.times
      if int_or_hash.is_a?(Integer)
        int_or_hash.times do 
          @deck << Object::const_get(class_name).new
        end
      ## If that line begins a hash then for each element in that hash check
      elsif int_or_hash.is_a?(Hash)
        int_or_hash.each do |card_name, number_of_cards_or_hash|
          ## If the value of that key is a Hash then for each key in that hash
          if number_of_cards_or_hash.is_a?(Hash)
            number_of_cards_or_hash.each do |card_value, number_of_cards|
              number_of_cards.times { @deck << Object::const_get(class_name).new(card_name.to_sym, card_value) }
            end
          #### If that key is an Integer then instantiate that class
          elsif number_of_cards_or_hash.is_a?(Integer)
            number_of_cards_or_hash.times do              
              @deck << Object::const_get(class_name).new(card_name)
            end
          end
        end
      end  
    end  
  end

  def shuffle
    RUBY_VERSION < "1.9" ? @deck.shuffle! : @deck.shuffle!(:random => Random.new(@seed))
  end

  def draw
    if @deck.size > 0
      @deck.pop
    else
      build
      shuffle 
      @deck.pop
    end
  end
end
