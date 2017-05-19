class Profile < ApplicationRecord
  mount_uploader :image_other, ProfilepicUploader
  belongs_to :user

  scope :shared, ->(profile_params) {
    where(uid: profile_params[:uid],  provider: profile_params[:provider])
  }
  scope :same_user, ->(user) { where(user_id: user.id) }
  default_scope { order("profile_id ASC") }

  # validate :disallow_login_on_shared_profiles

  def disallow_login_on_shared_profiles
    if shared(uid: uid, provider: provider).size > 1
      if allow_login
        errors.add(:allow_login, "must be false for shared profiles.")
      end
    end
  end

end
