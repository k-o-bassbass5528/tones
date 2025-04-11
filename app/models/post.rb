class Post < ApplicationRecord
    attachment :image
    belongs_to :user
    belongs_to :category
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :view_counts, dependent: :destroy

    validates :instrument, presence: true, length: { maximum: 50 }
    validates :text, presence: true, length: { maximum: 150 }
    validates :image, presence: true

    enum status: { published: 0, draft: 1 }

    def favorited_by?(user)
        favorites.where(user_id: user.id).exists?
    end
end