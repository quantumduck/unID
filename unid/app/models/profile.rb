class Profile < ApplicationRecord
  belongs_to :user

  scope :shared_profiles, ->(profile_params) {
    where(uid: profile_params[:uid],  provider: profile_params[:provider])
  }
  scope :same_user, ->(user) { where(user_id: user.id) }
end
