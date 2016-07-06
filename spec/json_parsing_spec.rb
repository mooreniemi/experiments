require 'spec_helper'
require 'json'

# https://developer.github.com/v3/
describe "parsing Github API" do
  let(:json_response) do
    JSON.parse(File.read('spec/support/github.json'))
  end
  it 'contains a bunch of urls' do
    expect(json_response[0].keys.select {|key| key =~ /url/}).to match_array(
      ["url", "repository_url", "labels_url", "comments_url", "events_url", "html_url"]
    )
  end
end
