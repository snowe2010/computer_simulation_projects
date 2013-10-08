require 'lady_bug_game/tile'
Dir["lady_bug_game/*.rb"].each {|file| require file}
# Dir["lady_bug_game/resources/*"].each {|file| require file}
Dir["lady_bug_game/tiles/*.rb"].each {|file| require file}
Dir["lady_bug_game/cards/*.rb"].each {|file| require file}

module LadyBugGame
  class LadyBugGame
    attr_accessor :players, :current_player, :current_player_go_again, :winner

    USAGE_MESSAGE = <<-HERE
    Usage: lady_bug_game.rb <seed> <A> <runs> <players>

      seed        A seed for the pRNG used in the simulation (a positive integer)
      capital_a   Capital A, representing this initial simulation experiment
      runs        The number of games to be played in the experiment (a positive integer)
      players     Represents the number of players to simulate ( a positive integer)

    HERE



    SUB_COMMANDS = %w(A B)

    def initialize
      # $log = Logger.new("logs/lady_bug_game.log", "daily")
      
      global_opts = Trollop::options do
        banner USAGE_MESSAGE
        version "LadyBugGame 0.1.0 (c) Tyler Thrailkill 2013"
        opt :verbose, "Outputs debugging details for all classes to STDOUT. If false, it will output to log files.", :short => :v
      end
      
      @seed = ARGV.shift.to_i
      Trollop::die USAGE_MESSAGE if not @seed.is_a? Integer # Something is wrong with this
      
      Trollop::Parser.new do
        stop_on SUB_COMMANDS
      end

      cmd = ARGV.shift # get the subcommand
      cmd_opts = case cmd
      when "A" # parse A options
        Trollop::die "Wrong number of Arguments for Capital A" if ARGV.length != 2
        @runs = ARGV.shift.to_i
        @number_of_players = ARGV.shift.to_i
      when "B"  # parse B options
        Trollop::die "Wrong number of Arguments for Capital B" if ARGV.length != 12
      else
        Trollop::die "unknown subcommand #{cmd.inspect}"
      end

      # puts "Global options: #{global_opts.inspect}"
      # puts "Subcommand: #{cmd.inspect}"
      # puts "Subcommand options: #{cmd_opts.inspect}"
      # puts "Remaining arguments: #{ARGV.inspect}"

      # output_usage if ARGV.size != 4

      # @seed = ARGV[0].to_i
      # @capital_a = ARGV[1]
      # @runs = ARGV[2].to_i
      # @number_of_players = ARGV[3].to_i

      output_usage if not (@seed.is_a?(Integer) && @runs.is_a?(Integer) && @number_of_players.is_a?(Integer))
      raise IncorrectNumberOfPlayers if (@number_of_players < 2 or @number_of_players > 4)
      @player_turns = []
      @player_wins = 0
    end

    def output_usage
      puts USAGE_MESSAGE
      exit(1)
    end

    def start
      @runs.times do |i|
        run_game
      end
      calculate_statistics
    end


    ## Main Game method. This creates the deck, runs the simulation, and loops
    def run_game
      # create and shuffle the deck
      @current_player_go_again = true # start true so first player always goes first
      @winner = false
      @players = []

      @deck = Deck.new "lady_bug_game/resources/main_deck.yml", @seed
      @deck.shuffle # shuffle the deck using the seed
      
      @number_of_players.times {|i| @players << Player.new(self, i)}
      @players[0].current_player = true
      @current_player = @players.each.select { |p| p.current_player == true  }

      # create the game pieces and place into bucket
      @game_pieces = GamePieces.new "lady_bug_game/resources/pieces.yml"

      # begin game
      while (!@winner) do
        select_player

        # draw and evaluate the card. Upon landing evaluate the landing
        draw_a_card @current_player

        #### Check if there is a winner

      end

      @players.each do |player|
        @player_turns << player.turns
        if player.winner == true and player == @players[0]
          @player_wins += 1
        end
      end

    end
    
    def select_player
      # find the current player
      current_player_index = @players.index {|player| player.current_player == true}
      if @current_player_go_again
        @current_player = @players[current_player_index]       #current player stays the same
        @current_player_go_again = false                       #mark go again flag false
      else
        @players[current_player_index].current_player = false
        current_player_index = (current_player_index >= @players.size-1 ? 0 : current_player_index += 1)
        @current_player = @players[current_player_index]     #choose next player in array
        @players[current_player_index].current_player = true #set the next player in the array as the current player
      end
    end

    def draw_a_card current_player
      current_player.evaluate_card @deck.draw 
    end

    def calculate_statistics
      @average_turns = @player_turns.inject(:+).to_f / @player_turns.size
      @standard_deviation = @player_turns.standard_deviation
      @fraction = (@player_wins.to_f/@runs).to_f
      puts "OUTPUT Average turns: #{@average_turns} Standard Deviation: #{@standard_deviation} Wins/Start: #{@fraction}"
    end
  end

  class IncorrectNumberOfPlayers < StandardError
  end
end

module Enumerable

  def sum
    self.inject(0){|accum, i| accum + i }
  end

  def mean
    self.sum/self.length.to_f
  end

  def sample_variance
    m = self.mean
    sum = self.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(self.length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end

end 
