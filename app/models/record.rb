class Record < ActiveRecord::Base
  scope :of, ->(type, day) {
    where('kind LIKE ?', type)
      .where(day: day)
      .first
  }

  def self.create_all_his
    Record.delete_all
    start = Date.new(2014, 10, 8)
    days = (Date.today - start).to_i
    rest_days = (Date.today - start).to_i % 7
    weeks = ((days - rest_days) / 7) + 1
    # 2014-10-08 から7日に1回
    weeks.times do |i|
      day = (start + (i * 7)).strftime('%Y-%m-%d')
      week_ago = (start + (i * 7) - 7).strftime('%Y-%m-%d')
      create_a_record_of(day, week_ago)
    end
  end

  def self.create_yesterday_his
    start = Date.new(2014, 10, 8)
    # 2014-10-08から7の倍数日経っていた場合
    if (Date.today - start).to_i % 7 == 0
      create_a_record_of(Date.today, Date.today - 7)
    end
  end

  def self.create_a_record_of(day, week_ago)
    # 総再生回数(一般)
    record = Record.new(day: day)
    record.kind = 'total_play_his'
    record.value = History.normal.play_count(day)
    record.save
    # 総再生回数(アダルト)
    record = Record.new(day: day)
    record.kind = 'total_play_his_a'
    record.value = History.adult.play_count(day)
    record.save
    # お気に入り総数
    record = Record.new(day: day)
    record.kind = 'total_fav'
    record.value = Fav.where("created_at < '#{day}'").size
    record.save
    # 登録ユーザ数総数
    record = Record.new(day: day)
    record.kind = 'total_reg_user'
    record.value = User.where("created_at < '#{day}'").size
    record.save
    # ユーザ数総数
    record = Record.new(day: day)
    record.kind = 'total_user'
    record.value = History.where("created_at < '#{day}'").group('user_id').length
    record.save
    # 動画総数
    record = Record.new(day: day)
    record.kind = 'total_video'
    record.value = Video.where("created_at < '#{day}'").size
    record.save
    # 動画情報更新総数
    record = Record.new(day: day)
    record.kind = 'total_updated_video'
    record.value =
      Video.where('created_at <> updated_at')
      .where("created_at >= '#{week_ago}'")
      .where("created_at < '#{day}'").size
    record.save
  end

  def self.create_reports
    start = Date.new(2014, 10, 8)
    days = (Date.today - start).to_i
    rest_days = (Date.today - start).to_i % 7
    weeks = ((days - rest_days) / 7) + 1
    result = {}
    videos, updated_videos, reg_users = [], [], []
    users, his, adult_his, favs = [], [], [], []
    weeks.times do |i|
      day = start + i * 7
      videos[i] = Record.of('total_video', day).value
      updated_videos[i] = Record.of('total_updated_video', day).value
      reg_users[i] = Record.of('total_reg_user', day).value
      users[i] = Record.of('total_user', day).value
      his[i] = Record.of('total_play_his', day).value
      adult_his[i] = Record.of('total_play_his_a', day).value
      favs[i] = Record.of('total_fav', day).value
    end
    result[:weeks] = weeks
    result[:videos] = videos
    result[:updated_videos] = updated_videos
    result[:reg_users] = reg_users
    result[:users] = users
    result[:playall] = his
    result[:playall_adult] = adult_his
    result[:favs] = favs
    result
  end
end
