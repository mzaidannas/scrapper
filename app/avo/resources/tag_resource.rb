class TagResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :name, as: :text
  field :description, as: :trix
  field :enabled, as: :boolean
  field :to_ignore, as: :boolean
  field :slug, as: :text, link_to_resource: true
  field :level, as: :number, readonly: true
  field :whole_word, as: :boolean
  field :case_sensitive, as: :boolean
  field :starting, as: :boolean
  field :ending, as: :boolean
  field :created_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true
  field :updated_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true

  field :parent, as: :belongs_to
  field :children, as: :has_many

  field :sources, as: :has_many
end
