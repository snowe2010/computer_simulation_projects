# coding: utf-8

## Top level module
module StochasticAreaNetworks
  
  ## Implements a Stochastic Area Network
  class StochasticAreaNetwork
    attr_reader :path_lengths

    # deprecated by use of generator
    # N = [ # empty column to counteract 0 based index
    #     [ 0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # empty row to counteract 0 index
    #     [ 0,  1,  1,  1,  0,  0,  0,  0,  0,  0], # rows correspond to j
    #     [ 0, -1,  0,  0,  1,  1,  0,  0,  0,  0], # columns correspond to k and i?
    #     [ 0,  0, -1,  0, -1,  0,  1,  1,  0,  0],
    #     [ 0,  0,  0, -1,  0,  0, -1,  0,  0,  1],
    #     [ 0,  0,  0,  0,  0, -1,  0,  0,  1,  0],
    #     [ 0,  0,  0,  0,  0,  0,  0, -1, -1, -1]
    #     ]

    A = {"12" => 3, "13" => 6, "14" => 13,
         "23" => 9, "25" => 3,
         "34" => 9, "36" => 7,
         "46" => 6,
         "56" => 3}

    def initialize(s, runs, file)
      @paths = []
      @path_lengths = {}
      @paths_with_point_estimates = {}
      srand(s)
      generate_matrix(file)
      calculate_paths 
      initialize_path_length_hash
      runs.times { calculate_time }
      calculate_point_estimates(runs.to_f)
    end

    def generate_matrix(input)
      paths = get_paths(input)
      generate_n_matrix(paths)
      fill_in_matrix_values(paths)
    end

    def get_paths(input)
      input ||= 'stochastic_area_networks/network.txt'
      paths = []
      IO.foreach(input) do |path|
        paths << path.split.collect {|x| x.to_i}
      end
      paths
    end

    def generate_n_matrix(paths)
      max = 0
      paths.each do |path|
        max = path[1] if path[1] > max
      end
      @n = Array.new(max+1) { Array.new(paths.size+1) {0} }
      @a = Array.new(max+1) { Array.new(max+1){0}}
    end

    def fill_in_matrix_values(paths)
      paths.each_with_index do |path, current_x_value| # 'inner arrays', this gets the x value
        @n[path[0]][current_x_value + 1] = 1
        @n[path[1]][current_x_value + 1] = -1
      end
      paths.each do |i, j, value|
        @a[i][j] = value.to_f
      end
    end

    def calculate_paths(j = 6, current_path = '') 
      k, l, t_max = 1, 0, 0.0
      while (l < b(j).abs)
        if @n[j][k] == -1
          i = 1
          i += 1 while @n[i][k] != 1
          cur_path = get_current_path(i, j, current_path)
          calculate_paths(i, cur_path)
          l += 1
        end
        k += 1
      end
      @paths.push(current_path) if j == 1
    end

    def calculate_time
      max_length = 0
      longest_path = ''
      @paths.each do |path|
        path_length = calculate_length_of_path(path)
        if path_length > max_length
          max_length = path_length
          longest_path = path
        end
      end
      @path_lengths[longest_path] += 1.0000
    end

    def calculate_length_of_path(path)
        path_length = 0
        path.split.each do |arc|

          i, j = arc[1].chr.to_i, arc[2].chr.to_i
          path_length += y(i,j)
        end
        path_length
    end

    def calculate_point_estimates(runs)
      @path_lengths.update(@path_lengths) { |k,v| "%.4f" % (v/runs)}
    end

    def b(j)
      @n[j].count { |i| i == -1}
    end

    def y(i, j)
      RUBY_VERSION > '1.9' ? rand(1..@a[i][j]) : rand(@a[i][j])
    end

    def get_current_path(i, j, current_path)
      # "#{'OUTPUT    :' if i == 1}a#{i}#{j}#{current_path == ':' ? current_path : ",#{current_path}"}"
      "a#{i}#{j}#{current_path == '' ? current_path : " #{current_path}"}"
    end

    def print_output
      @path_lengths.each do |key, value|
        puts "OUTPUT\t:#{key.gsub(/\s/, ',')}:\t#{value}"
      end
    end

    def initialize_path_length_hash
      @paths.each { |path| @path_lengths[path] = 0.0000 }
    end
  end
end