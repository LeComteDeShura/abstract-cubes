require_relative 'spec_helper'
require_relative '../lib/ser_des/config_loader'

describe ConfigLoader do
  describe '.load' do
    let(:loaded_data) { ConfigLoader.load(File.expand_path('../saves/base', __dir__)) }
    subject { loaded_data }

    it { is_expected.to be_a Array }
    it { expect(loaded_data[0]).to be_a Player }
    it { expect(loaded_data[1]).to be_a Setting }
  end
end
