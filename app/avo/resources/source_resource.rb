class SourceResource < Avo::BaseResource
  self.title = :name
  self.includes = %i[tag]
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :name, as: :text
  field :url, as: :text, format_using: -> (url) { url.nil? ? url : link_to(url, url, target: '_blank') }
  field :logo_url, as: :external_image
  field :enabled, as: :boolean
  field :description, as: :trix
  field :slug, as: :text, link_to_resource: true
  field :created_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true
  field :updated_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true
  field :schedule, as: :select, options: Source.schedules
  field :tag_names, as: :tags, suggestions: -> { Tag.pluck(:name) }
end
