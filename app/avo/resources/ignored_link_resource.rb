class IgnoredLinkResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  end

  # add fields here
  field :id, as: :id, readonly: true
  field :link, as: :text
  field :regex, as: :text
  field :description, as: :trix
  field :global, as: :boolean
  field :source, as: :belongs_to
  field :created_at, as: :date_time, format: "yyyy-LL-dd TT", timezone: "Asia/Karachi", readonly: true
  field :updated_at, as: :date_time, format: "yyyy-LL-dd TT", timezone: "Asia/Karachi", readonly: true
end
