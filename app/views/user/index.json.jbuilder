json.data(@users) do |user|
  json.extract! user, :id, :fullname, :email
  json.url user_url(user, format: :json)
end
