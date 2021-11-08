require_relative './setting'

class SettingSerializer
  def initialize(setting)
    @setting = setting
  end

  def serialize
    {
      'health_enemy' => @setting.health_enemy,
      'power_enemy' => @setting.power_enemy,
      'spawn_time_enemy' => @setting.spawn_time_enemy,
      'min_enemies' => @setting.min_enemies,
      'path_to_mesh_enemy' => @setting.path_to_mesh_enemy,
      'difficult_game' => @setting.difficult_game,
      'radius_spawn' => @setting.radius_spawn,
      'on_render' => @setting.on_render
    }
  end
end
