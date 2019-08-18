class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_name(params[:name])

    if user
      $tracker.track(user.id, 'Login')
      # TODO 既存のユーザの名前を登録するために入れているので、2020年になったらここは消す。 (新規登録時に登録されるので)
      $tracker.people.set(user.id, {'$first_name' => user.name})
    end

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      toast :success, 'ログインしました'
    else
      toast :error, 'IDかパスワードが間違っています'
    end
    redirect_to previous_page_path
  end

  def destroy
    $tracker.track(user_id, 'Logout')

    session[:user_id] = nil
    toast :success, 'ログアウトしました'
    redirect_to previous_page_path
  end
end
