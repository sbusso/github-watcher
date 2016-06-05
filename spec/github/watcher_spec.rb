require 'spec_helper'

describe Github::Watcher do
  let!(:client) {
      Github::Watcher::Client.new('e79d833368c77d1a8bb05841e968b19b8acf867e')
   }
  subject { client }
  it { is_expected.to respond_to(:search) }

  it "should get an array of repositories" do
    VCR.use_cassette('github') do
      expect(client.search('smtp', 'go')).to be_a(Array)
    end
  end

end