require_relative '../lib/menu/new_game'

describe NewGame do
  describe '#next' do
    let(:player) { GameLoader.load_player('../saves/base_test') }
    let(:setting) { GameLoader.load_setting('../saves/base_test') }

    context 'when enter name of file' do
      let(:context) { AppContext.new(NewGame.new, player, setting) }
      let(:input) { StringIO.new("\r") }
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
