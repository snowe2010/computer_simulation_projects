# encoding: UTF-8

## This handles all the stuff
module SisCircularArray

  ## This class actually handles all the stuff
  class SisCircularArray
    attr_accessor :item_cost, :setup, :hold, :shortage

    # def self.get_demand file
    #   @demand = []
    #   File.foreach(file) { |line| @demand << line }
    #   @demand
    # end

    def initialize(s, file, index)
      @inventory_level_at = []
      @order_at = []
      @demand_at = [0]
      @s = s
      @big_s ||= 80

      # circular array if index isn't 0
      index != 0 ? @demand = RingBuffer.new(@big_s) : @demand = []
      @index ||= index

      File.foreach(file) { |line| @demand << line.to_i }
      @demand.compact
      @n = @demand.size.to_f
      # class << self; puts @demand; end
      # puts @demand
    end

    def algorithm_1_3_1
      @inventory_level_at[0] = @big_s
      i = 0
      while i < @demand.size
        i += 1
        if @inventory_level_at[i - 1] < @s
          @order_at[i - 1] = @big_s - @inventory_level_at[i - 1]
        else
          @order_at[i - 1] = 0
        end
        @demand_at[i] = get_demand(i - 1)
        @inventory_level_at[i] = @inventory_level_at[i - 1] + @order_at[i - 1] - @demand_at[i]
      end
      @order_at[i] = @big_s - @inventory_level_at[i]
      @inventory_level_at[i] = @big_s
    end

    def get_demand (index)
      @demand[@index + index]
    end

    def average_demand
      # summation of all members of demand from 1 to size divided by size
      @demand_at.reduce(:+) / @n
    end

    def average_order
      # sum of all members of order from 1 to size divided by size
      @order_at.reduce(:+) / @n
    end

    def time_averaged_holding_level
      time_averaged_holding_level_array.reduce(:+) / @n
    end

    def time_averaged_shortage_level
      time_averaged_shortage_level_array.reduce(:+) / @n
    end

    def order_frequency
      @order_at.count { |e| e != 0 } / @n
    end

    private

    def time_averaged_holding_level_array
      # l'_(i-1) = l_(i-1) + o_(i-1)
      i = 0
      l_plus ||= []
      while i < @n - 1
        i += 1
        if @demand_at[i] <= l_prime(i)
          l_plus << (l_prime(i) - (@demand_at[i] / 2)).round
        else
          l_plus << (((l_prime(i))**2) / (2 * @demand_at[i].to_f)).round
        end
      end
      l_plus

      # @inventory_level_at.zip(@order_at, @demand_at).drop(1).each_with_index.map do |zipped, index|
      #   inventory_level, order, demand  = zipped
      #   if demand < l_prime(index)
      #     (l_prime(index) - (demand/2)).round(2)
      #   else
      #     ((l_prime(index))**2)/(2 * demand.to_f).round(2)
      #   end
      # end.compact
    end

    def time_averaged_shortage_level_array
      i = 0
      l_minus = []
      while i < @n - 1
        i += 1
        if @demand_at[i] > l_prime(i)
          l_minus << (((@demand_at[i] - l_prime(i))**2) / ( 2 * @demand_at[i].to_f)).round
        end
      end
      l_minus << 0 if l_minus.empty?
      l_minus

      # @inventory_level_at.zip(@order_at, @demand_at).drop(1)
      #                    .each_with_index.map do |zipped, index|
      #   inventory_level, order, demand  = zipped
      #   if demand > l_prime(index)
      #     ((demand - l_prime(index))**2)/(2 * demand.to_f).round(2)
      #   end
      # end.compact

    end

    def l_prime (index)
      @inventory_level_at[index - 1] + @order_at[index - 1]
    end
  end
end


# class RingBuffer < Array
#   attr_reader :max_size

#   def initialize(max_size, enum = nil)
#     @max_size = max_size
#     enum.each { |e| self << e } if enum
#   end

#   def <<(el)
#     if self.size < @max_size || @max_size.nil?
#       super
#     else
#       self.shift
#       self.push(el)
#     end
#   end

#   alias_method :push, :<<
# end
