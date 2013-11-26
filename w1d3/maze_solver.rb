#!/usr/bin/env ruby

class MazeSolver
  def initialize(maze)
    @maze = maze
    @closed_list = []
    @open_list = []
  end

  def show
    @maze.each do |line|
      print line.join
      print "\n"
    end
  end

  def start_node
    @maze.each_with_index do |row, x|
      row.each_with_index do |el, y|
        if el =="S"
          return Node.new(nil, 0, 0, [x,y])
        end
      end
    end
  end

  def current_square
    current_square = @open_list.first
    f = current_square.f

    @open_list.each do |node|
      if node.f < f
        current_square = node
      end
    end
    current_square
  end

  def neighbors(node)
    x,y = node.pos
    neighbor_nodes = []

    [-1, 1].each do |n|
      neighbor_nodes << @maze[x+n][y])
      neighbor_nodes << @maze[x][y+n]
      neighbor_nodes << @maze[x+n][y+n]
      neighbor_nodes << @maze[x-n][y+n]
    end

    neighbor_nodes
  end

  def solve
    @open_list << start_node

    until @open_list.empty?
      current_node = current_square
      neighbor_nodes = neighbors(node)
      @closed_list << current_node
      @open_list.delete_at(@open_list.index(node))

      neighbor_nodes.each do |node|
      end
    end

  end
end

class Node
  attr_reader :f, :pos

  def initialize(parent, g, h, pos, el)
    @parent = parent
    @g = g
    @h = h
    @f = g + h
    @pos = pos
    @el = el
  end

end

if $PROGRAM_NAME == __FILE__

  maze = []

  File.foreach(ARGV[0]) do |f|
    maze << f.chomp.split('')
  end

  solver = MazeSolver.new(maze)
  solver.show
end