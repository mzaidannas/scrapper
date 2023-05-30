class UserResource < Avo::BaseResource
  self.devise_password_optional = true
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :email, as: :text, link_to_resource: true
  field :password, as: :password
  field :name, as: :text
  field :user_type, as: :select, enum: ::User.user_types, display_with_value: true
  field :created_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true
  field :updated_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi", readonly: true
  field :last_seen_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi"
  field :reset_password_token, as: :text
  field :reset_password_sent_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi"
  field :remember_created_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi"
  field :sign_in_count, as: :number
  field :current_sign_in_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi"
  field :last_sign_in_at, as: :date_time, format: "yyyy-LL-dd tt", timezone: "Asia/Karachi"
  field :current_sign_in_ip, as: :text
  field :last_sign_in_ip, as: :text

  action ExportCsv
end
