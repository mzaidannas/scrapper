class TagGroup < ApplicationRecord
    validates :name, :slug, presence: true
    validates :slug, uniqueness: true

    has_many :tags, dependent: :destroy
    has_many :sources, dependent: :destroy
end
