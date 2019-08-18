require 'rails_helper'
include DataHelper

RSpec.describe 'HomeScenario', type: :feature, js: true do
  before(:each) do
    create_base_data
  end

  describe 'necessary info' do
    it 'should be found in top page', js: true do
      visit '/'
      expect(page).to have_content('NewArritalVideo')
      click_link('人気')
      sleep 1
      expect(page).to have_content('f*ckingtosh11')
      click_link('資料館')
      sleep 1
      expect(page).to have_content('キーワード')
      click_link('設定/使い方')
      sleep 1
      expect(page).to have_content('画面サイズ')
    end
  end

  describe 'search' do
    scenario 'search videos', js: true do
      visit '/'
      fill_in 'keyword', with: 'f*ckingtosh'
      click_button('検　索')
      sleep 1
      expect(page).to have_content('12 entries')

      video = Video.last
      video.bookmarks = 4000
      video.duration = '12:34'
      video.save

      fill_in 'keyword', with: video.title
      select 'これはヤバい(2000~)', from: 'bookmarks'
      select '少し短め(10~30分)', from: 'duration'
      click_button('検　　索')
      sleep 1
      expect(page).to have_content('12:34')
      expect(page).to have_content('1 entries')
    end
  end
end
