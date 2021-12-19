require 'yaml'
require_relative './setting'
require_relative './setting_serializer'

class SettingDeserializer
  def initialize(hash)
    @hash = hash
  end

  def deserialize
    setting = Setting.new @hash['path_to_mesh_enemy'], @hash['difficult_game'],
                          @hash['min_enemies'], @hash['on_render']
    setting.init_enemy_setting @hash['radius_spawn'], @hash['health_enemy'],
                               @hash['power_enemy'], @hash['spawn_time_enemy']
  end
end
