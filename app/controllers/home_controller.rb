# Home Controller
class HomeController < ApplicationController
  include InitializeAction

  before_action :save_current_url, only: [:play, :search]
  after_action :flash_clear, only: [:search]

  def index
    set_user_info
    set_ranking
  end

  def coming_soon
    render layout: false
  end

  def log
  end

  def play
    @video = Video.find_by_title(params[:title])
    return redirect_to root_url unless available_video?

    $tracker.track(user_id, 'Play Video')
    $tracker.track(user_id, 'Play ' + @video.title)
    $tracker.people.increment(user_id, {'Playing Videos' => 1})

    set_ranking
    set_user_info
    @window = Window.new(window_size)
    create_watch_history
    render :index
  end

  def search
    set_search_conditions

    keywords_str = @keywords_array.join(',')
    $tracker.track(user_id, 'Search')
    $tracker.track(user_id, "Search #{keywords_str} #{@bookmarks} #{@duration}")

    @results = Video.search(@keywords_array, @bookmarks, @duration)
    toast :warning, '検索結果が多すぎるため、一部のみ表示しています' if @results.count == SEARCH_LIMIT

    SearchHis.create(keyword: @keyword,
                     favs: @bookmarks,
                     duration: @duration,
                     user_id: user_id)
    set_previous_search_condition
  end

  def report
    $tracker.track(user_id, '404Report')

    if Video.find_by_title(params[:title]).destroy
      toast :success, '報告を受け取りました。ご協力ありがとうございます!'
    else
      toast :error, '報告に失敗しました。もう一度試してみてください。'
    end
    redirect_to previous_page_path
  end

  private

  def available_video?
    if @video.blank?
      toast :error, 'タイトルに何か問題があるようです'
      false
    elsif !@video.available_on_fc2?
      toast :error, 'この動画はFC2で既に削除されているようです'
      @video.destroy
      false
    else
      true
    end
  end

  def create_watch_history
    if session[:previous_video_url] != @video.url
      History.create(user_id: user_id,
                     keyword: session[:keyword_re],
                     video_id: @video.id)
    end
    session[:previous_video_url] = @video.url
  end

  def set_search_conditions
    search_keyword = params[:keyword] || ''
    @keyword = (search_keyword.gsub(/(　)+/, "\s"))
    @keywords_array = @keyword.split("\s")
    @bookmarks = params[:bookmarks] || DEFAULT_BOOKMARKS_OPTION
    @duration = params[:duration] || DEFAULT_DURATION_OPTIONS
  end

  def set_previous_search_condition
    session[:keyword_pre] = @keyword
    session[:bookmarks_pre] = @bookmarks
    session[:duration_pre] = @duration
  end
end
