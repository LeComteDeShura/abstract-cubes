require 'matrix'
require_relative '../enemy/enemy'
# class Weapon
#     def initialize
#         @damage =
#     end
# end

class Player
  attr_accessor :command, :position, :health, :ray_direction, :angle_rotation, :power, :angle_x

  # def initialize(health: 0, power: 0, position: 0, angle_rotation: 0)
  #   self.health = [health, 1].max
  #   self.power = [power, 1].max
  #   self.position = position
  #   self.angle_rotation = angle_rotation
  #   @angle_x = 0
  #   @ray_direction = Vector[1, 0, 0]
  #   @command = ''
  # end

  def initialize(health = 100, power = 10, position = Vector[0, 0, 0], angle_rotation = 1.57)
    @health = [[health, 1].max, 100].min
    @power = [power, 1].max
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
    c = position.dot(position) - 1 * 1
    h = b * b - c
    return Vector[-1.0, -1.0] if h < 0.0

    h = Math.sqrt(h)
    Vector[-b - h, -b + h]
  end

  def do(key, enemies)
    case key
    when 'exit'
      @command = 'exit'
      return false, enemies
    when '0'
      @command = 'attack'

      enemies.each do |enemy|
        it = intersect_enemy enemy.position
        enemy.take_damage @power if it[0] > 0.0
        # p i, enemies[i].position
        # if enemies[i].position[0] == 0
        #   enemies[i].take_damage(@power) if enemies[i].position[1] / enemies[i].position[1].abs == @ray_direction[1]
        # elsif enemies[i].position[1] == 0
        #   enemies[i].take_damage(@power) if enemies[i].position[0] / enemies[i].position[0].abs == @ray_direction[0]
        # end
      end
      return false, enemies
    when 'right'
      @angle_x += @angle_rotation
      trans
      @command = 'right'
      return true, enemies
    when 'left'
      @angle_x -= @angle_rotation
      trans
      @command = 'left'
      return true, enemies
    when 'up'
      @position += @ray_direction.round
      @command = 'up'
      return false, enemies
    when 'down'
      @position -= @ray_direction.round
      @command = 'down'
      return false, enemies
    when 'p'
      @command = 'skip'
      return false, enemies
    end
    [true, enemies]
  end
end
