class User < ApplicationRecord
  has_many :favs
  has_many :histories
  has_secure_password
  validates :name, presence: true, uniqueness: true

  def save_and_rewrite_his(tmp_user_id)
    ApplicationRecord.transaction do
      save
      if tmp_user_id.present?
        History.rename_user_history(tmp_user_id, id)
        SearchHis.rename_user_history(tmp_user_id, id)
      end
    end
    true
  rescue
    false
  end

  def unique?
    !User.find_by_name(name)
  end

  def fav_list
    Fav.list(id)
  end
end
