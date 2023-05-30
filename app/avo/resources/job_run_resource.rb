class JobRunResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id, readonly: true
  field :name, as: :text, readonly: true
  field :params, as: :text, readonly: true
  field :status,
    as: :status,
    failed_when: [:error, :warning],
    loading_when: [:pending],
    readonly: true
  field :error_message, as: :text, readonly: true, only_on: [:index]
  field :error_detail, as: :textarea, readonly: true, hide_on: [:index]
  field :completed_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true
  field :created_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true
  field :updated_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true

  action ExportCsv
end
