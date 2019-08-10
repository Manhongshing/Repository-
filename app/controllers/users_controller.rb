class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  after_action :flash_clear, only: [:update]

  def create
    $tracker.track(user_id, 'Register User')
    temp_user_id = user_id

    @user = User.new(user_params)
    @user.size = DEFAULT_WINDOW_SIZE
    if valid_user?
      if @user.save_and_rewrite_his(session[:user_id])
        toast :success, '登録しました'
      else
        toast :error, '登録に失敗しました。もう一度試してみてください'
      end
    end

    $tracker.people.set(@user.id, {'$first_name' => @user.name});
    $tracker.alias(@user.id, temp_user_id)

    redirect_to previous_page_path
  end

  def destroy
    if @user.destroy
      session[:user_id] = nil
      toast :success, 'アカウントを削除しました'
    else
      toast :error, 'アカウントの削除に失敗しました。もう一度試してみてください'
    end
    redirect_to root_url
  end

  # Ajax for updating window size
  def update
    $tracker.track(user_id, 'update Window size')

    @window = Window.new(window_params[:size])
    if @window.valid? && @user.update(window_params)
      toast :success, "ウィンドウサイズを #{@window.category} に変更しました。"
    else
      toast :error, 'サイズ変更に失敗しました。もう一度試してみてください'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user)
      .permit(:name,
              :password,
              :password_confirmation,
              :password_digest)
  end

  def window_params
    params.require(:user).permit(:size)
  end

  def valid_user?
    if !@user.unique?
      toast :error, 'そのID名は既に使われています'
      false
    elsif user_params[:password] != user_params[:password_confirmation]
      toast :error, 'パスワードが異なっています'
      false
    else
      true
    end
  end
end
