json.data(@nivelacesso) do |nivelacesso|
  json.extract! nivelacesso, :descricao,adm_id
  json.url nivelacesso_url(nivelacesso, format: :json)
end
