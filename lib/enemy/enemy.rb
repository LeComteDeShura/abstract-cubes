require 'matrix'

class Enemy
  attr_accessor :power, :position, :color, :radius_spawn

  def initialize(init_health = 255, radius_spawn = 10, power = 1)
    @position = Vector[0.0, 0.0, 0.0]
    @radius_spawn = radius_spawn
    @power = power
    init_health = [[init_health, 255].min, 1].max / 255.0
    @color = Vector[init_health, 0, 0.4, 0.5].round(2)
  end

  def load(position, color)
    @position = position
    @color = color
    self
  end

  def spawn(position_player, difficult_game)
    fi = rand(0..360)
    @position = Vector[position_player[0] + @radius_spawn * Math.cos(fi),
                       position_player[1] + @radius_spawn * Math.sin(fi), 0.0].round
    @power += difficult_game

    self
  end

  def do(position_player)
    len = Math.sqrt((position_player[0] - @position[0])**2 + (position_player[1] - @position[1])**2)
    return false if len.ceil <= 1

    fi = Math.atan2(-(@position[1] - position_player[1]), -(@position[0] - position_player[0]))
    x = Math.cos(fi).round
    y = Math.sin(fi).round
    x.zero? ? x = 0 : y = 0
    @position += Vector[x, y, 0.0]

    true
  end

  def dead?
    return true if @color[0] <= 0

    false
  end

  def take_damage(power)
    @color[0] = ((@color[0] * 255.0 - power) / 255.0).round(2)
  end
end

# enemy = Enemy.new
#
# enemy.spawn Vector[0, 0], 0
#
#
#
# while enemy.do Vector[0, 0]
#
# end
