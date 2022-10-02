class ScrapedNewsResource < Avo::BaseResource
  self.title = :slug
  self.includes = %i[tags sources]
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], headline_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :link, as: :text, format_using: -> (url) { url.nil? ? url : link_to(url, url, target: '_blank') }
  field :headline, as: :text
  field :description, as: :trix
  field :slug, as: :text, link_to_resource: true
  field :datetime, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi"
  field :visible, as: :boolean
  field :created_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true
  field :updated_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true

  field :tag_names, as: :tags, suggestions: -> { Tag.pluck(:name) }
  field :source_names, as: :tags, suggestions: -> { Source.pluck(:name) }
end
