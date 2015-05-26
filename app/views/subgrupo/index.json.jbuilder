json.data(@sub_grupo) do |sub_grupo|
  json.extract! sub_grupo, :descricao, grupo_id
  json.url sub_grupo_url(sub_grupo, format: :json)
end
