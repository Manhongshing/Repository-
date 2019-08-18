require 'rails_helper'
include DataHelper

RSpec.describe 'BugReportScenario', type: :feature, js: true do
  before(:each) do
    create_base_data
  end

  describe 'create a bug report' do
    scenario 'report a bug', js: true do
      pre_count = BugReport.count
      visit '/'
      click_button('バグ報告')
      sleep 1
      fill_in 'content', with: '重大なバグがありました'
      sleep 2
      click_button('送信')

      sleep 1

      expect(page).to have_content('ご報告ありがとうございます')
      expect(BugReport.count - pre_count).to eq 1
      expect(BugReport.last.content).to eq '重大なバグがありました'
    end
  end
end
