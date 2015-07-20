class ChangeDataCstipi < ActiveRecord::Migration
  def change
  	if Ipicst.exists?(codigo: "49")
  		Ipicst.find(Ipicst.where(codigo: "49").first.id).update_attributes(codigo: "9", descricao: "Outras Entradas/Saídas")
  	end
  end
end
