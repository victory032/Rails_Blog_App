class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         :confirmable
  has_many :posts, inverse_of: :author, foreign_key: :author_id
  has_many :comments, inverse_of: :author, foreign_key: :author_id
  has_many :likes, inverse_of: :author, foreign_key: :author_id

  validates :name, presence: true

  def recent_posts(limit = 3)
    posts.order(created_at: :desc).limit(limit)
  end
end
