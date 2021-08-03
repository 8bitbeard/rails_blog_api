class Article < ApplicationRecord
  validates :title, presence: true,
                    length: { minimum: 3 },
                    uniqueness: { case_sensitive: false }
  validates :body, presence: true

  belongs_to :user
end
