require './lib/ser_des/game_loader'

describe GameLoader do
  describe '#load' do
    let(:loaded_data) { GameLoader.new('base_test').load }
    subject { loaded_data }

    it { is_expected.to be_a Array }
    it { expect(loaded_data[0]).to be_a Player }
    it { expect(loaded_data[1]).to be_a Setting }
    it { expect(loaded_data[2]).to be_a Array }
  end
end
