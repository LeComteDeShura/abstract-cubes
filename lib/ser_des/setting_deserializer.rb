require 'yaml'
require_relative './setting'
require_relative './setting_serializer'

class SettingDeserializer
  def initialize(hash)
    @hash = hash
  end

  def deserialize
    # p @hash
    Setting.new @hash["health_enemy"], @hash["power_enemy"], @hash["spawn_time_enemy"], @hash["min_enemies"],
                @hash["path_to_mesh_enemy"], @hash["radius_spawn"], @hash["difficult_game"], @hash["on_render"]
  end
end

# setting = Setting.new(255, 1, 10, 1, 'data/cube.obj', 0, 10)
# # player = Player.new
# yaml = SettingSerializer.new(setting).serialize.to_yaml
# File.open("teeeeeeeeeeesssssssssssssssttttttttt", 'w') { |file| file.write(yaml) }
#
# data = YAML.load_stream(File.open("teeeeeeeeeeesssssssssssssssttttttttt"))[0]
# puts data
# setting2 = SettingDeserializer.new(data).deserialize
# p setting2.health_enemy
