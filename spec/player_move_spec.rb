require_relative '../lib/player/players_move'

describe PlayersMove do
  describe '#next' do
    let(:player) { GameLoader.load_player('../saves/base_test') }
    let(:setting) { GameLoader.load_setting('../saves/base_test') }

    context 'when pressed m key' do
      let(:context) { AppContext.new(PlayersMove.new, player, setting) }
      let(:input) { StringIO.new('m') }
      before do
        $stdin = input
        context.do
        context.next
      end

      subject { context.state }
      it { is_expected.to be_a SubMenu }
    end

    context 'when pressed p key' do
      let(:context) { AppContext.new(PlayersMove.new, player, setting) }
      let(:input) { StringIO.new('p') }
      before do
        $stdin = input
        context.do
        context.next
      end
      subject { context.state }
      it { is_expected.to be_a Planner }
    end

    context 'when pressed e key' do
      let(:context) { AppContext.new(PlayersMove.new, player, setting) }
      let(:input) { StringIO.new('e') }
      before do
        $stdin = input
        context.do
        context.next
      end
      subject { context.state }
      it { is_expected.to be_a Planner }
    end
  end
end
