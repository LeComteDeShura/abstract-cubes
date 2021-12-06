require_relative '../lib/menu/new_game'

describe NewGame do
  describe "#do" do
    context "stdin.gets 123" do
      it "transition_to Planner" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        context = AppContext.new(NewGame.new, player, setting)
        $stdin.should_receive(:gets).and_return("\r")
        expect(context.state.is_a?(NewGame)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(Planner)).to eq true
      end
    end
  end
end
