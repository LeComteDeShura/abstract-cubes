require 'matrix'
require_relative '../player/player'

class PlayerSerializer
  def initialize(player)
    @player = player
  end

  def serialize
    {
      'health' => @player.health,
      'position' => @player.position,
      'angle_rotation' => @player.angle_rotation,
      'power' => @player.power
    }
  end
end
