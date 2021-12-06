require_relative '../abstract/context'
require_relative '../player/player'
require_relative '../ser_des/setting'
require 'json'

class AppContext < Context
  attr_accessor :player, :enemies, :flag, :difficult_game, :number_enemies, :enemy_command, :name_save, :setting, :js

  def initialize(state, player = nil, setting = nil, enemies = [])
    super(state)
    @name_save = ''
    @player = player
    @enemies = enemies
    @setting = setting
    @flag = true

    @min_enemies = setting.min_enemies
    @path_to_mesh_enemy = setting.path_to_mesh_enemy
    @difficult_game = setting.difficult_game
    @spawn_time = setting.spawn_time_enemy
    @number_enemies = @min_enemies
    calculate_number_enemies
    spawn_enemies
    update_position_enemies
    return unless setting.on_render

    fork do
      system(File.expand_path("../renderer/render", __dir__.to_s))
    end
  end

  def load(player, setting, enemies, name_save)
    @name_save = name_save
    @flag = true
    @difficult_game = setting.difficult_game
    @path_to_mesh_enemy = setting.path_to_mesh_enemy
    @min_enemies = setting.min_enemies
    @spawn_time = setting.spawn_time_enemy
    @number_enemies = @min_enemies

    @player = player
    @setting = setting
    @enemies = enemies
    p '   ', @enemies.length, @number_enemies, @difficult_game, @setting.radius_spawn
    calculate_number_enemies
    spawn_enemies
    update_position_enemies
    p @enemies.length, @number_enemies
  end

  def render
    file = File.open(File.expand_path("../pipe/image", __dir__.to_s), "r")
    image = file.read
    file.close
    print "\e[1;1H"
    print image.to_s
  end

  def calculate_number_enemies
    @number_enemies = (@difficult_game / @spawn_time).to_i + @min_enemies
    @number_enemies
  end

  def spawn_enemies
    (@enemies.length..@number_enemies - 1).each do |_i|
      enemy = Enemy.new(@setting.health_enemy, @setting.radius_spawn, @setting.power_enemy)
      enemy.spawn @player.position, @difficult_game
      @enemies.push enemy
    end
    @enemies
  end

  def update_position_enemies
    @js = JSON.parse("{\"js\": \"js\"}")
    @js.clear
    i = 0

    @enemies.each do |enemy|
      @js[i.to_s] = {
        'mesh': @path_to_mesh_enemy,
        'position': { 'x': enemy.position[0], 'y': enemy.position[1], 'z': enemy.position[2] },
        'color': { 'r': enemy.color[0], 'g': enemy.color[1], 'b': enemy.color[2], 'a': enemy.color[3] }
      }
      i += 1
    end
    path = File.expand_path("../pipe/enemies.json", __dir__.to_s)
    # path = '../pipe/enemies.json'
    # path = File.expand_path(path, __dir__.to_s)
    File.open(path, 'w') do |file|
      JSON.dump(@js, file)
    end
    @js
  end
end
