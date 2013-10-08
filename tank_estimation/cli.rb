# encoding: UTF-8

require 'tank_estimation/version'
require 'tank_estimation/trollop'
require 'tank_estimation/tank_estimation'

## Module to contain all other modules
module TankEstimation

  ## The actual command line implementation of the program
  ## This handles user input
  class CLI

    USAGE_MESSAGE = <<-HERE
    Usage: SIM <capital_letter> <n> <seed> <runs> [options]

    TankEstimation 

    HERE
    SUB_COMMANDS = %w{T}
    T_MESSAGE =  <<-HERE
    T <n> <seed> <runs> [options]
       n:   An integer specifying the number of tanks
    seed:   An integer to specify the seed 
    runs:   An integer specifying the number of times to run the simulation
    HERE

    def initialize
      get_command
      number_of_tanks, seed, runs = get_parameters
      te = TankEstimation::TankEstimation.new(number_of_tanks, seed, runs)
      te.print_output
    end

    def get_command
      global_opts = Trollop.options do
        banner USAGE_MESSAGE
        version 'TankEstimation 0.1.0 (c) Tyler Thrailkill 2013'
        opt :verbose, 'Outputs debugging details for all classes to STDOUT. If false, it will output to log files.', :short => :v
        stop_on SUB_COMMANDS
      end
    end

    def get_parameters
      cmd = ARGV.shift # get the subcommand
      cmd_opts =  case cmd
      when 'T' # parse B options
        t_case
      else
        Trollop.die "unknown subcommand #{cmd.inspect}"
      end
    end

    def t_case
      Trollop.options do
        banner T_MESSAGE
      end

      Trollop.die 'Wrong number of Arguments for Capital T' if ARGV.length != 3
      Trollop.die '<n> needs to be an integer' unless ARGV[0].is_i?
      Trollop.die '<seed> needs to be an integer' unless ARGV[1].is_i?
      Trollop.die '<runs> needs to be an integer' unless ARGV[2].is_i?

      number_of_tanks = ARGV.shift.to_i
      seed = ARGV.shift.to_i
      runs = ARGV.shift.to_i
      return number_of_tanks, seed, runs
    end
  end
end

class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end