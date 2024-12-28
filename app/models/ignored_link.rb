class IgnoredLink < ApplicationRecord
  validate :any_present?

  belongs_to :source, optional: true

  def any_present?
    if %w[link regex].all? { |attr| self[attr].blank? }
      errors.add :base, "Atleast one column is required."
    end
  end
end
