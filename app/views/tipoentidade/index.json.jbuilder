json.data(@tipoentidades) do |tipoentidade|
  json.extract! tipoentidade, :descricao
  json.url empresa_url(tipoentidade, format: :json)
end
