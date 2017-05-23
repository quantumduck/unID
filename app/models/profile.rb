class Profile < ApplicationRecord
  mount_uploader :image_other, ProfilepicUploader
  belongs_to :user

  scope :shared, ->(profile_params) {
    where(uid: profile_params[:uid],  provider: profile_params[:provider])
  }
  scope :same_user, ->(user) { where(user_id: user.id) }

  validates :url, :name, presence: true
  # validate :disallow_login_on_shared_profiles

  def short_description
    maxlength = 50
    unless description
      return provider.capitalize + ' profile'
    end
    output = description.split('\n').first
    unless output
      return provider.capitalize + ' profile'
    end
    if output.length > maxlength
      output = output[0, maxlength - 3] + '...'
    elsif output.length == 0
      output = provider.capitalize + ' profile'
    end
    output
  end

  def disallow_login_on_shared_profiles
    if shared(uid: uid, provider: provider).size > 1
      if allow_login
        errors.add(:allow_login, "must be false for shared profiles.")
      end
    end
  end

end
