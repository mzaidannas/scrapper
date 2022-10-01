class ScrapedNewsResource < Avo::BaseResource
  self.title = :slug
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], headline_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :link, as: :text
  field :headline, as: :text
  field :description, as: :trix
  field :slug, as: :text
  field :datetime, as: :date_time
  field :visible, as: :boolean
  field :created_at, as: :text, readonly: true
  field :updated_at, as: :text, readonly: true

  field :tag_names, as: :tags, suggestions: -> { Tag.pluck(:name) }
end
