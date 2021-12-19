require_relative '../player/player'
require 'matrix'
require 'yaml'
require_relative './player_serializer'

class PlayerDeserializer
  def initialize(hash)
    @hash = hash
  end

  def deserialize
    Player.new [@hash['health'], @hash['power']], @hash['position'], @hash['angle_rotation']
  end
end
