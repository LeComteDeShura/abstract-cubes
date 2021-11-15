require 'yaml'
require_relative './setting'
require_relative './setting_deserializer'
require_relative '../player/player'
require_relative './player_deserializer'

class ConfigLoader
  def initialize(file)
    @file = file
  end

  def load
    player_data = YAML.load_stream(File.open("#{@file}/base_player.yaml"))[0]
    setting_data = YAML.load_stream(File.open("#{@file}/base_setting.yaml"))[0]
    player = PlayerDeserializer.new(player_data).deserialize
    setting = SettingDeserializer.new(setting_data).deserialize
    [player, setting]
  end

  def self.load(file)
    new(file).load
  end
end

# player, setting = ConfigLoader.load(File.expand_path('save/base', __dir__))
