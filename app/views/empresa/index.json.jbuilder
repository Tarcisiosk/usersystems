json.data(@empresas) do |empresa|
  json.extract! empresa, :id, :razao_social, :nome_fantasia, :cnpj, :insc_estadual, :insc_municipal, :endereco
  json.url empresa_url(empresa, format: :json)
end
