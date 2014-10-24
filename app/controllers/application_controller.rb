class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # 例外ハンドル
  if Rails.env == 'production' || Rails.env == 'test'
    rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, with: :render_404
    rescue_from Exception, with: :render_500
  end

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: 'layouts/application', status: 404 }
    end
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end
    respond_to do |format|
      format.html { render template: 'errors/error_500', layout: 'layouts/application', status: 500 }
    end
  end


  private

  def set_fc2_info
    begin
      page = Nokogiri::HTML(open(@url))
      @title = page.css('meta[@itemprop="name"]').attr('content').value
      @duration = page.css('meta[@property="video:duration"]').attr('content').value
      @title.include?("Removed") ? false : true
    rescue
      false
    end
  end

  def set_root_info
    if current_user
      @favs = current_user.fav_list
      @histories = current_user.history_list
    else
      session[:temp_id] ||= rand(8999999)+1000000
      @user = User.new
      @histories = History.list(session[:temp_id])
    end
    @week = WeeklyRank.all
    @month = MonthlyRank.all
  end

  def set_play_info
    set_root_info
    set_player_size
    @adult = session[:adult]
    @bug_report = BugReport.new

    #再生できない報告後のリンク先のため
    session[:referer_url] = request.env['HTTP_REFERER']
  end

  def set_player_size
    if current_user
      @fav = Fav.new
      @height = (current_user.size*0.6125).round
      @width = current_user.size
    elsif session[:size]
      @height = (session[:size]*0.6125).round
      @width = session[:size]
    else
      @height = 446
      @width = 728
    end
  end

  def window_size(size)
    case size
    when 590
      "小"
    when 750
      "中"
    when 900
      "大"
    else
      false
    end
  end

  def adult_url?
    if @url =~ /\/a\//
      session[:adult] = true
    else
      session[:adult] = false
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def toast(type, text)
    flash[:toastr] = { type => text }
  end

  def flash_clear
    flash[:toastr] = nil
  end

end