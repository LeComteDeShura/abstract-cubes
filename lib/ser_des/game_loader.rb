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
    @filename_player = File.expand_path("../../saves/#{filename}/player.yaml", __dir__)
    @filename_setting = File.expand_path("../../saves/#{filename}/setting.yaml", __dir__)
    @filename_enemies = File.expand_path("../../saves/#{filename}/enemies.json", __dir__)
  end

  def load
    data_setting = YAML.load_stream(File.open(@filename_setting))[0]
    data_player = YAML.load_stream(File.open(@filename_player))[0]

    setting = SettingDeserializer.new(data_setting).deserialize
    player = PlayerDeserializer.new(data_player).deserialize

    enemies = []
    lol = File.open(@filename_enemies).read
    js = JSON.parse(lol)

    (0..js.length - 1).each do |i|
      position = Vector[js[i.to_s]['position']['x'],
                        js[i.to_s]['position']['y'],
                        js[i.to_s]['position']['z']]

      color = Vector[js[i.to_s]['color']['r'],
                     js[i.to_s]['color']['g'],
                     js[i.to_s]['color']['b'],
                     js[i.to_s]['color']['a']]
      enemies.push Enemy.new(power = setting.power_enemy).load(position, color)
    end

    [player, setting, enemies]
  end

  def valid?
    Pathname.new(@filename_setting).exist?
    Pathname.new(@filename_player).exist?
  end
end

# player, setting = ConfigLoader.load(File.expand_path('save/base', __dir__))
#
# saver = GameSaver.new '1', player, setting
# saver.save
#
# loader = GameLoader.new '1'
# player2, setting2, enemies = loader.load
