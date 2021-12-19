require_relative '../lib/main/planner'

describe Planner do
  describe '#next' do
    let(:player) { GameLoader.load_player('../saves/base_test') }
    let(:setting) { GameLoader.load_setting('../saves/base_test') }

    context 'when it is players turn' do
      let(:context) { AppContext.new(Planner.new, player, setting) }
      before { context.next }
      subject { context.state }
      it { is_expected.to be_a PlayersMove }
    end

    context 'when it is enemies turn' do
      let(:context) { AppContext.new(Planner.new, player, setting) }
      before do
        context.flag = false
        context.next
      end
      subject { context.state }
      it { is_expected.to be_a EnemiesMove }
    end
  end
end
