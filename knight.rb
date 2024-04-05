# frozen_string_literal: false

# Chess Class
class Chess
  attr_accessor :board, :position

  def initialize
    @board = Array.new(8) { Array.new(8, ' ') } # 8x8 chessboard
    @position = adjust([0, 0])
  end

  def adjust(position)
    position[1] = (position[1] - 7).abs # Y is shifted, and only Y
    position
  end

  def adjust_y(y_value)
    (y_value - 7).abs
  end

  def valid_moves(position)
    moves = []
    moves << [position[0] - 2, position[1] - 1] if position[0] >= 2 && position[1] >= 1 # Left - Up
    moves << [position[0] - 1, position[1] - 2] if position[0] >= 1 && position[1] >= 2 # Up - Left
    moves << [position[0] + 1, position[1] - 2] if position[0] <= 6 && position[1] >= 2 # Up - Right
    moves << [position[0] + 2, position[1] - 1] if position[0] <= 5 && position[1] >= 1 # Right - Up
    moves << [position[0] + 2, position[1] + 1] if position[0] <= 5 && position[1] <= 6 # Right - Down
    moves << [position[0] + 1, position[1] + 2] if position[0] <= 6 && position[1] <= 5 # Down - Right
    moves << [position[0] - 1, position[1] + 2] if position[0] >= 1 && position[1] <= 5 # Down - Left
    moves << [position[0] - 2, position[1] + 1] if position[0] >= 2 && position[1] <= 6 # Left - Down
    moves
  end

  def valid?(position)
    return false if position[0].negative? || position[0] > 7 || position[1].negative? || position[1] > 7

    true
  end

  def knight_moves(start, final)
    exit if valid?(start) == false || valid?(final) == false

    update_position([start[0], adjust_y(start[1])], final)

    prev_tree = solve(start, final)
    path = reconstruct_path(start, final, prev_tree)

    puts "You made it in #{path.length - 1} moves! Here's your path: "
    p path
  end

  def update_position(start, final)
    @position = start
    @board[@position[1]][@position[0]] = 'H'
    @board[adjust_y(final[1])][final[0]] = 'X'
  end

  def display
    @board.each { |i| p i; puts '' }
  end

  def solve(start, final)
    q = []
    q << start # Enqueue by adding start to the queue

    visited = []
    visited << start

    prev_tree = Array.new(8) { Array.new(8, nil) } # Keeps an array of previous positions

    while q.empty? == false
      node = q.shift
      neighbours = valid_moves(node)

      neighbours.each_with_index do |element, i|
        if visited.include?(neighbours[i]) == false
          q << element
          visited << element
          prev_tree[element[1]][element[0]] = node
          return prev_tree if element == final
        end
      end
    end
    nil
  end

  def reconstruct_path(start, final, prev_tree)
    path = []
    path << final
    current = final

    while current != start
      current = prev_tree[current[1]][current[0]]
      path << current
    end

    path[-1] = start
    path.reverse
  end
end

game = Chess.new
game.knight_moves([0, 0], [7, 7])
game.display
