# encoding: UTF-8

require 'stochastic_area_networks/version'
require 'stochastic_area_networks/trollop'
require 'stochastic_area_networks/stochastic_area_network'

## Module to contain all other modules
module StochasticAreaNetworks

  ## The actual command line implementation of the program
  ## This handles user input
  class CLI

    USAGE_MESSAGE = <<-HERE
    Usage: SIM <capital_letter> <s> <runs> [file]

    StochasticAreaNetworks takes two different sets of arguments, one for B and one for F.

    If <capital_letter> is B, then there is no need to supply a file
    If <capital_letter> is F, then you must supply a properly formatted data file.

    Specify R -h or F -h to get help for each command.

    HERE
    SUB_COMMANDS = %w{B F}
    B_MESSAGE =  <<-HERE
    B <seed> <runs> [options]
    seed:   An integer to specify the seed 
    runs:   An integer specifying the number of times to run the simulation
    HERE
    F_MESSAGE = <<-HERE
    F <seed> <runs> <network.txt> [options]
    seed:   An integer to specify the seed 
    runs:   An integer specifying the number of times to run the simulation
    network.txt:  A file in the network system format, <exit_node> <enter_node> <path_length>   
    HERE

    def initialize
      get_command
      s, runs, file = get_parameters
      san = StochasticAreaNetworks::StochasticAreaNetwork.new(s,runs,file)
      # puts "OUTPUT :#{},#{},#{},#{}:"
      san.print_output
    end

    def get_command
      global_opts = Trollop.options do
        banner USAGE_MESSAGE
        version 'SisCircularArray 0.1.0 (c) Tyler Thrailkill 2013'
        opt :verbose, 'Outputs debugging details for all classes to STDOUT. If false, it will output to log files.', :short => :v
        stop_on SUB_COMMANDS
      end
    end

    def get_parameters
      cmd = ARGV.shift # get the subcommand
      cmd_opts =  case cmd
      when 'B' # parse B options
        b_case
      when 'F'  # parse F options
        f_case
      else
        Trollop.die "unknown subcommand #{cmd.inspect}"
      end
    end

    def b_case
      Trollop.options do
        banner B_MESSAGE
      end

      Trollop.die 'Wrong number of Arguments for Capital B' if ARGV.length != 2
      Trollop.die '<s> needs to be an integer' unless ARGV[0].is_i?
      Trollop.die '<runs> needs to be an integer' unless ARGV[1].is_i?

      s = ARGV.shift.to_i
      runs = ARGV.shift.to_i
      return s, runs
    end

    def f_case
      Trollop.options do
        banner F_MESSAGE
      end
      Trollop.die 'Wrong number of Arguments for Capital F' if ARGV.length != 3
      Trollop.die '<s> need to be an integer ' unless ARGV[0].is_i?
      Trollop.die '<runs> need to be an integer' unless ARGV[1].is_i?
      Trollop.die '<network.txt> needs to be a filename in the current directory' unless File.file?(ARGV[2])
      s = ARGV.shift.to_i
      runs = ARGV.shift.to_i
      file = ARGV.shift

      return s, runs, file
    end

  end

end

class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end