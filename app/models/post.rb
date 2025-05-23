class Post < ApplicationRecord
    has_many_attached :images
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :view_counts, dependent: :destroy

    validates :instrument, presence: true, length: { maximum: 60 }
    validates :text, presence: true, length: { maximum: 240 }
    validates :images, presence: true, on: :create
    belongs_to :category
    validate :validate_image_count

    enum status: { published: 0, draft: 1 }
    scope :published, -> { where(status: :published) }

    def favorited_by?(user)
        favorites.where(user_id: user.id).exists?
    end

    def images=(attachables)
        return if attachables == [""] || attachables.blank?
        super
    end

    private
    def validate_image_count
        if images.attached? && images.count > 4
            errors.add(:images, "は4枚までしか添付できません")
        end
    end
end