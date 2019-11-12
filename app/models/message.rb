class Message < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validate :present_error

  def present_error
      if content.present? or image.present? 
      else
        errors.alert
    end
  end
  mount_uploader :image, ImageUploader
end
