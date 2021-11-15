require 'yaml'
require 'fileutils'
require 'pathname'
require_relative './player_serializer'
require_relative './setting_serializer'

class GameSaver
  def initialize(filename, player, setting)
    pathdir = File.expand_path("../../saves/#{filename}/", __dir__)
    FileUtils.mkdir pathdir unless Pathname.new(pathdir).exist?
    @filename_player = "#{pathdir}/player.yaml"
    @filename_setting = "#{pathdir}/setting.yaml"
    @filename_enemies_src = File.expand_path('../pipe/enemies.json', __dir__)
    @filename_enemies_dest = "#{pathdir}/enemies.json"

    @player = player
    @setting = setting
  end

  def save
    yaml_setting = SettingSerializer.new(@setting).serialize.to_yaml
    yaml_player = PlayerSerializer.new(@player).serialize.to_yaml

    File.open(@filename_setting, 'w') { |file| file.write(yaml_setting) }
    File.open(@filename_player, 'w') { |file| file.write(yaml_player) }
    FileUtils.cp @filename_enemies_src, @filename_enemies_dest
  end
end
