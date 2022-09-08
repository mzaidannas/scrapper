class Tag < ApplicationRecord
    validates :name, :slug, presence: true
    validates :slug, uniqueness: true

    belongs_to :tag_group
end
