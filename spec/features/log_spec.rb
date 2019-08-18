require 'rails_helper'
include DataHelper

RSpec.describe 'LogScenario', type: :feature, js: true do
  before(:each) do
    create_base_data
  end

  describe 'check fc2play version' do
    it 'log should be save version as top page' do
      visit '/log'
      log_ver = find("#wrapper > div.panel-body > ul > li:nth-child(2) > div > div.timeline-heading > h4").text

      visit '/'
      top_ver = find("#wrapper > center > font > p > a").text

      expect(log_ver).to eq(top_ver)
    end
  end
end
