require_relative '../lib/menu/sub_menu'

describe SubMenu do
  describe '#next' do
    let(:player) { GameLoader.load_player('../saves/base_test') }
    let(:setting) { GameLoader.load_setting('../saves/base_test') }

    context 'when pressed enter' do
      let(:context) { AppContext.new(SubMenu.new, player, setting) }
      let(:input) { StringIO.new("\r") }
      before do
        $stdin = input
        context.do
        context.next
      end

      subject { context.state }
      it { is_expected.to be_a Planner }
    end

    context 'when pressed arrow down and enter' do
      let(:context) { AppContext.new(SubMenu.new, player, setting) }
      let(:input) { StringIO.new("B\r") }
      before do
        $stdin = input
        context.do
        context.next
      end
      subject { context.state }
      it { is_expected.to be_a SubMenu }
    end

    context 'when pressed arrow down and enter' do
      let(:context) { AppContext.new(SubMenu.new, player, setting) }
      let(:input) { StringIO.new("BB\r") }
      before do
        $stdin = input
        context.do
        context.next
      end
      subject { context.state }
      it { is_expected.to be_a Continue }
    end
  end
end
