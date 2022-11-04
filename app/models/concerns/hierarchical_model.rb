# frozen_string_literal: true

module HierarchicalModel
  extend ActiveSupport::Concern

  included do
    belongs_to :parent, foreign_key: hierarchical_foreign_key, class_name: name, inverse_of: :children, optional: true
    has_many :children, foreign_key: hierarchical_foreign_key, class_name: name, dependent: :nullify, inverse_of: :parent
    accepts_nested_attributes_for :children,
                                  allow_destroy: true

    alias_attribute :parent_id, hierarchical_foreign_key if hierarchical_foreign_key != :parent_id

    before_save :compute_level
  end

  class_methods do
    def hierarchical_foreign_key
      :parent_id
    end
  end

  # TODO: Optimise recursive query
  def ancestors
    ancestors_and_self.where.not(id: id)
  end

  def ancestors_and_self
    self_table = Arel::Table.new(self.class.table_name.to_sym)
    parent_table = Arel::Table.new(:with_parent)

    anchor_term = self_table.project(self_table[Arel.star]).where(self_table[:id].eq(id))
    recursive_term = self_table.project(self_table[Arel.star]).join(parent_table).on(self_table[:id].eq(parent_table[:parent_id]))
    self.class.with(:recursive, with_parent: anchor_term.union(recursive_term)).from("with_parent AS #{self.class.table_name}")
  end

  def self_and_descendants
    self_table = Arel::Table.new(self.class.table_name.to_sym)
    child_table = Arel::Table.new(:with_children)

    anchor_term = self_table.project(self_table[Arel.star]).where(self_table[:id].eq(id))
    recursive_term = self_table.project(self_table[Arel.star]).join(child_table).on(self_table[:parent_id].eq(child_table[:id]))
    self.class.with(:recursive, with_children: anchor_term.union(recursive_term)).from("with_children AS #{self.class.table_name}")
  end

  def descendants
    self_and_descendants.where.not(id: id)
  end

  def top_parent
    return self if parent.blank?

    ancestors_and_self.find_by(level: 0)
  end

  def all_related
    self_table = Arel::Table.new(self.class.table_name.to_sym)
    parent_table = Arel::Table.new(:with_parent)
    child_table = Arel::Table.new(:with_children)

    anchor_term = self_table.project(self_table[Arel.star]).where(self_table[:id].eq(id))
    parent_recursive_term = self_table.project(self_table[Arel.star]).join(parent_table).on(self_table[:id].eq(parent_table[:parent_id]))
    child_recursive_term = self_table.project(self_table[Arel.star]).join(child_table).on(self_table[:parent_id].eq(child_table[:id]))
    self.class.with(
      :recursive,
      with_children: anchor_term.union(child_recursive_term),
      with_parent: anchor_term.union(parent_recursive_term)
    ).from("(SELECT * FROM with_children UNION SELECT * FROM with_parent) AS #{self.class.table_name}")
  end

  private

  def level_column?
    self.class.column_names.include? 'level'
  end

  def compute_level
    return unless level_column?
    return self.level = 0 if parent_id.blank?

    self.level = parent.level + 1
  end
end
