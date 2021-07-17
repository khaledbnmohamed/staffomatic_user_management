class User < ApplicationRecord
  has_paper_trail
  has_secure_password

  validates :email, presence: true, uniqueness: true

  # scopes
  scope :archived,      -> { where(archived: true) }
  scope :unarchived,  -> { where(archived: false) }

end
