require_relative '../enemy/enemy'
require_relative './config_loader'
require_relative './game_saver'
require_relative './player_deserializer'
require_relative './setting_deserializer'
require 'yaml'
require 'json'
require 'pathname'

class GameLoader
  def initialize(filename = 'base')
    @filename_player = File.expand_path("../../saves/#{filename}/player.yaml", __dir__.to_s)
    @filename_setting = File.expand_path("../../saves/#{filename}/setting.yaml", __dir__.to_s)
    @filename_enemies = File.expand_path("../../saves/#{filename}/enemies.json", __dir__.to_s)
  end

  def load
    player = load_player
    setting = load_setting
    enemies = load_enemy setting
    [player, setting, enemies]
  end

  def load_player
    data_player = YAML.load_stream(File.open(@filename_player))[0]
    PlayerDeserializer.new(data_player).deserialize
  end

  def load_setting
    data_setting = YAML.load_stream(File.open(@filename_setting))[0]
    SettingDeserializer.new(data_setting).deserialize
  end

  def load_enemy(setting)
    js_file = File.open(@filename_enemies)
    js_e = JSON.parse(js_file.read)
    js_file.close

    enemies = []
    (0..js_e.length - 1).each do |i|
      position = Vector[js_e[i.to_s]['position']['x'],
                        js_e[i.to_s]['position']['y'],
                        js_e[i.to_s]['position']['z']]

      color = Vector[js_e[i.to_s]['color']['r'],
                     js_e[i.to_s]['color']['g'],
                     js_e[i.to_s]['color']['b'],
                     js_e[i.to_s]['color']['a']]
      enemies.push Enemy.new(power = setting.power_enemy).load(position, color)
    end
    enemies
  end

  def self.load_player(file)
    new(file).load_player
  end

  def self.load_setting(file)
    new(file).load_setting
  end

  def self.load_enemy(file, setting)
    new(file).load_enemy(setting)
  end

  def valid?
    Pathname.new(@filename_setting).exist?
    Pathname.new(@filename_player).exist?
  end
end
