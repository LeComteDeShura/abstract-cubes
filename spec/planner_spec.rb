# require_relative '../lib/main/app_context'

describe Planner do
  describe "#do" do
    context "" do
      it "transition_to PlayersMove" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        context = AppContext.new(Planner.new, player, setting)
        expect(context.state.is_a?(Planner)).to eq true
        context.do
        context.next
        expect(context.state.is_a?(PlayersMove)).to eq true
      end
    end

    context "" do
      it "transition_to EnemiesMove" do
        player, setting = ConfigLoader.load(File.expand_path('../saves/base_test', __dir__))
        context = AppContext.new(Planner.new, player, setting)
        expect(context.state.is_a?(Planner)).to eq true
        context.do
        context.flag = false
        context.next
        expect(context.state.is_a?(EnemiesMove)).to eq true
      end
    end
  end
end
