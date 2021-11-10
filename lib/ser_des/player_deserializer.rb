require_relative '../player/player'
require 'matrix'
require 'yaml'
require_relative './player_serializer'

class PlayerDeserializer
  def initialize(hash)
    @hash = hash
  end

  def deserialize
    # p @hash
    Player.new @hash["health"], @hash["power"], @hash["position"], @hash["angle_rotation"]
  end
end

# player = Player.new(100, 10, Vector[0, 0, 0], 1.57)
# # player = Player.new
# yaml = PlayerSerializer.new(player).serialize.to_yaml
# File.open("teeeeeeeeeeesssssssssssssssttttttttt", 'w') { |file| file.write(yaml) }
#
# data = YAML.load_stream(File.open("teeeeeeeeeeesssssssssssssssttttttttt"))[0]
# puts data
# player2 = PlayerDeserializer.new(data).deserialize
# p player2.health
