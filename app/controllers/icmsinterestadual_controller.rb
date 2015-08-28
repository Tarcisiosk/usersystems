class IcmsinterestadualController < ApplicationController
  def index
  	@estados = Estado.all.order("descricao")
  	@icmsinterestaduals = Icmsinterestadual.all 
  end  

  def saveIcmsinterestadual
  	JSON.parse(params[:icmsinterestaduals]).each do |iie|
  		if iie['id'].blank?
  			Icmsinterestadual.create(iie)
  		else
  			@Icmsinterestadual = Icmsinterestadual.find(iie['id'])
  			@Icmsinterestadual.update(iie)
  		end	
  	end	
    render :json => Icmsinterestadual.all.to_json.to_s.html_safe
  end
end
