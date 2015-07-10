class AddDataEstado < ActiveRecord::Migration
  def change
  	Estado.destroy_all
  	ActiveRecord::Base.connection.reset_pk_sequence!('estados')
  	unless Estado.exists?(uf: 'AC')
  		Estado.create(:codigo_ibge => '12', :uf => 'AC', :descricao => 'Acre', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'AL')
  		Estado.create(:codigo_ibge => '27', :uf => 'AL', :descricao => 'Alagoas', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'AM')
  		Estado.create(:codigo_ibge => '13', :uf => 'AM', :descricao => 'Amazonas', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'AP')
  		Estado.create(:codigo_ibge => '16', :uf => 'AP', :descricao => 'Amapá', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'BA')
  		Estado.create(:codigo_ibge => '29', :uf => 'BA', :descricao => 'Bahia', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'CE')
  		Estado.create(:codigo_ibge => '23', :uf => 'CE', :descricao => 'Ceará', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'DF')
  		Estado.create(:codigo_ibge => '53', :uf => 'DF', :descricao => 'Distrito Federal', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'ES')
  		Estado.create(:codigo_ibge => '32', :uf => 'ES', :descricao => 'Espírito Santo', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'GO')
  		Estado.create(:codigo_ibge => '52', :uf => 'GO', :descricao => 'Goiás', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'MA')
  		Estado.create(:codigo_ibge => '21', :uf => 'MA', :descricao => 'Maranhão', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'MT')
  		Estado.create(:codigo_ibge => '51', :uf => 'MT', :descricao => 'Mato Grosso', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'MS')
  		Estado.create(:codigo_ibge => '50', :uf => 'MS', :descricao => 'Mato Grosso do Sul', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'MG')
  		Estado.create(:codigo_ibge => '31', :uf => 'MG', :descricao => 'Minas Gerais', :icms_interno => '18', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'PA')
  		Estado.create(:codigo_ibge => '15', :uf => 'PA', :descricao => 'Pará', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'PB')
  		Estado.create(:codigo_ibge => '25', :uf => 'PB', :descricao => 'Paraíba', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'PR')
  		Estado.create(:codigo_ibge => '41', :uf => 'PR', :descricao => 'Paraná', :icms_interno => '18', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'PE')
  		Estado.create(:codigo_ibge => '26', :uf => 'PE', :descricao => 'Pernambuco', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'PI')
  		Estado.create(:codigo_ibge => '23', :uf => 'PI', :descricao => 'Piauí', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'RN')
  		Estado.create(:codigo_ibge => '24', :uf => 'RN', :descricao => 'Rio Grande do Norte', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'RS')
  		Estado.create(:codigo_ibge => '43', :uf => 'RS', :descricao => 'Rio Grande do Sul', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'RJ')
  		Estado.create(:codigo_ibge => '33', :uf => 'RJ', :descricao => 'Rio de Janeiro', :icms_interno => '19', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'RO')
  		Estado.create(:codigo_ibge => '11', :uf => 'RO', :descricao => 'Rondônia', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'RR')
  		Estado.create(:codigo_ibge => '14', :uf => 'RR', :descricao => 'Roraima', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'SC')
  		Estado.create(:codigo_ibge => '42', :uf => 'SC', :descricao => 'Santa Catarina', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'SP')
  		Estado.create(:codigo_ibge => '35', :uf => 'SP', :descricao => 'São Paulo', :icms_interno => '18', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'SE')
  		Estado.create(:codigo_ibge => '28', :uf => 'SE', :descricao => 'Sergipe', :icms_interno => '17', :diferimento => '1')
  	end
  	unless Estado.exists?(uf: 'TO')
  		Estado.create(:codigo_ibge => '17', :uf => 'TO', :descricao => 'Tocantins', :icms_interno => '17', :diferimento => '1')
  	end
  end
end
