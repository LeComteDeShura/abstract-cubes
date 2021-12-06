require './lib/ser_des/game_saver'

describe GameSaver do
  describe '.save' do
    context 'gamesave'
    it {
      expect(0).to be_a Integer

      game_saver = GameSaver.new('base_test', Player.new, Setting.new)
    }
  end
end
