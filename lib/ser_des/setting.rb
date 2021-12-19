class Setting
  attr_accessor :health_enemy, :power_enemy,
                :spawn_time_enemy, :min_enemies,
                :path_to_mesh_enemy, :difficult_game,
                :radius_spawn, :on_render

  def initialize(path_to_mesh_enemy, difficult_game = 0, min_enemies = 0, on_render = 0)
    @min_enemies = min_enemies
    @path_to_mesh_enemy = path_to_mesh_enemy
    @difficult_game = difficult_game
    @on_render = on_render
  end

  def init_enemy_setting(radius_spawn,
                         health_enemy = 0,
                         power_enemy = 0,
                         spawn_time_enemy = 0)
    @health_enemy = health_enemy
    @power_enemy = power_enemy
    @spawn_time_enemy = spawn_time_enemy
    @radius_spawn = radius_spawn
    self
  end
end
