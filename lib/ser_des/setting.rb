class Setting
  attr_accessor :health_enemy, :power_enemy, :spawn_time_enemy, :min_enemies, :path_to_mesh_enemy, :difficult_game,
                :radius_spawn, :on_render

  def initialize(health_enemy, power_enemy, spawn_time_enemy, min_enemies, path_to_mesh_enemy, radius_spawn, difficult_game, on_render)
    @health_enemy = health_enemy
    @power_enemy = power_enemy
    @spawn_time_enemy = spawn_time_enemy
    @min_enemies = min_enemies
    @path_to_mesh_enemy = path_to_mesh_enemy
    @difficult_game = difficult_game
    @radius_spawn = radius_spawn
    @on_render = on_render
  end
end
