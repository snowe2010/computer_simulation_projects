# encoding: UTF-8

require 'sis_circular_array/version'
require 'sis_circular_array/trollop'
require 'sis_circular_array/sis_circular_array'

## Module to contain all other modules
module SisCircularArray

  ## The actual command line implementation of the program
  ## This handles user input
  class CLI

    USAGE_MESSAGE = <<-HERE
      SisCircularArray takes two different sets of arguments, one for R and one for C.
      Specify R -h or C -h to get help for each command.
    HERE
    SUB_COMMANDS = %w{R C}
    R_MESSAGE =  <<-HERE
 R <s> <demand.dat> [options]
          s:   An integer that specifies the level at which an order will be placed
 demand.dat:   A file with something something something
          HERE
    C_MESSAGE = <<-HERE
 C <s> <demand.dat> <index> [options]
           s:   An integer that specifies the level at which an order will be placed
  demand.dat:   A file with something something something
       index:   Specifies something
          HERE

    def initialize

      global_opts = Trollop.options do
        banner USAGE_MESSAGE
        version 'SisCircularArray 0.1.0 (c) Tyler Thrailkill 2013'
        opt :verbose, 'Outputs debugging details for all classes to STDOUT. If false, it will output to log files.', :short => :v
        stop_on SUB_COMMANDS
      end

      cmd = ARGV.shift # get the subcommand
      cmd_opts = case cmd
      when 'R' # parse A options

        Trollop.options do
          banner R_MESSAGE
        end
        Trollop.die 'Wrong number of Arguments for Capital R' if ARGV.length != 2
        Trollop.die '<s> needs to be an integer' unless ARGV[0].is_i?
        Trollop.die '<demand.dat> needs to be a filename in the current directory' unless File.file?(ARGV[1])

        s = ARGV.shift.to_i
        file = ARGV.shift
        index = 0
        # ::SisCircularArray::SisCircularArray.get_demand file
      when 'C'  # parse B options
        Trollop.options do
          banner C_MESSAGE
        end
        Trollop.die 'Wrong number of Arguments for Capital C' if ARGV.length != 3
        Trollop.die '<s> need to be an integer ' unless ARGV[0].is_i?
        Trollop.die '<demand.dat> needs to be a filename in the current directory' unless File.file?(ARGV[1])
        Trollop.die '<index> need to be an integer' unless ARGV[2].is_i?
        s = ARGV.shift.to_i
        file = ARGV.shift
        index = ARGV.shift.to_i
      else
        Trollop.die "unknown subcommand #{cmd.inspect}"
      end

      # if s == 81
      #   100.times do |i|
      #     sis = ::SisCircularArray::SisCircularArray.new i, file, index
      #     inven, ord = sis.algorithm_1_3_1
      #     # puts (sis.time_averaged_shortage_level * 700)
      #   end  
      # elsif index == 101
      #   100.times do |i|
      #     # puts i
      #     sis = ::SisCircularArray::SisCircularArray.new s, file, i
      #     inven, ord = sis.algorithm_1_3_1
      #     puts (sis.time_averaged_shortage_level * 700)
      #     # puts (sis.time_averaged_shortage_level * 700) + (sis.time_averaged_holding_level * 25) + (sis.order_frequency * 1000)
      #   end 
      # else
        sis = ::SisCircularArray::SisCircularArray.new s, file, index
        sis.algorithm_1_3_1
        setup_cost = sis.order_frequency * 1000
        shortage_cost = sis.time_averaged_shortage_level * 700
        holding_cost = sis.time_averaged_holding_level * 25
        dependant_cost = setup_cost + shortage_cost + holding_cost
        puts "OUTPUT #{setup_cost} #{shortage_cost} #{holding_cost} #{dependant_cost}"
      # end

    end
  end

end

class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end

## This is an implementation of a partially-complete circular array
## for handling the C parameter from commandline input
class RingBuffer < Array
  attr_reader :max_size
  alias_method :array_element, :[]

  def initialize(max_size, enum = nil)
    @max_size = max_size
    enum.each { |e| self << e } if enum
  end

  def <<(el)
    if self.size < @max_size || @max_size.nil?
      super
    else
      self.shift
      self.push(el)
    end
  end

  def [](offset = 0)
     self.array_element(offset % self.size)
  end

  alias_method :push, :<<
end
