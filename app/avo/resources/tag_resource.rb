class TagResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :name, as: :text
  field :description, as: :trix
  field :slug, as: :text
  field :level, as: :number, readonly: true
  field :created_at, as: :date_time, format: "yyyy-LL-dd TT", timezone: "Asia/Karachi", readonly: true
  field :updated_at, as: :date_time, format: "yyyy-LL-dd TT", timezone: "Asia/Karachi", readonly: true

  field :parent, as: :belongs_to
  field :children, as: :has_many

  field :sources, as: :has_many
end
