class UserResource < Avo::BaseResource
  self.devise_password_optional = true
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :email, as: :text
  field :password, as: :password
  field :name, as: :text
  field :user_type, as: :select, enum: ::User.user_types, display_with_value: true
end
