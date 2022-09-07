class TagGroup < ApplicationRecord
    validates :name, :slug, presence: true
    validates :slug, uniqueness: true
end
