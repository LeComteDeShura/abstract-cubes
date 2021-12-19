require 'matrix'
require_relative '../enemy/enemy'
# class Weapon
#     def initialize
#         @damage =
#     end
# end

class Player
  attr_accessor :command, :position, :health, :ray_direction, :angle_rotation, :power, :angle_x

  def initialize(health = [100, 10], position = Vector[0, 0, 0], angle_rotation = 1.57)
    @health = [[health[0], 1].max, 100].min
    @power = [health[1], 1].max
    @position = position
    @angle_rotation = angle_rotation
    @angle_x = 0
    @ray_direction = Vector[1, 0, 0]
    @command = ''
  end

  def trans
    x = Math.cos(@angle_x)
    y = Math.sin(@angle_x)

    @ray_direction[0] = x.round(2)
    @ray_direction[1] = y.round(2)
    @ray_direction
  end

  def dead?
    # return true if @health <= 0
    @health <= 0
    # false
  end

  def take_damage(power)
    @health -= power
  end

  def intersect_enemy(position)
    position = @position - position
    b = position.dot(@ray_direction)
    c = position.dot(position) - (0.5 * 0.5)
    h = (b * b) - c
    return Vector[-1.0, -1.0] if h < 0.0

    h = Math.sqrt(h)
    Vector[-b - h, -b + h]
  end

  def shoot(enemies)
    enemies.each do |enemy|
      it = intersect_enemy enemy.position
      enemy.take_damage @power if it[0] > 0.0
    end
    enemies
  end

  def do(key, enemies)
    move, enemies = do_no_pass key, enemies
    move, enemies = do_pass key, enemies if move
    [move, enemies]
  end

  def do_no_pass(key, enemies)
    case key
    when 'q'
      @command = 'exit'
      return false, enemies
    when 'e'
      @command = 'attack'
      return false, shoot(enemies)
    when 'p'
      @command = 'skip'
      return false, enemies
    when 'w'
      @position += @ray_direction.round
      @command = 'up'
      return false, enemies
    when 's'
      @position -= @ray_direction.round
      @command = 'down'
      return false, enemies
    end
    [true, enemies]
  end

  def do_pass(key, enemies)
    case key
    when 'd'
      @angle_x += @angle_rotation
      trans
      @command = 'right'
      return true, enemies
    when 'a'
      @angle_x -= @angle_rotation
      trans
      @command = 'left'
      return true, enemies
    end
    [true, enemies]
  end
end
