json.data(@grupos) do |grupo|
  json.extract! grupo, :descricao
  json.url empresa_url(grupo, format: :json)
end
