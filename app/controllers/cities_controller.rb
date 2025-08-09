class CitiesController < ApplicationController
  def index
    @cities = if params[:province_id].present?
                City.where(province_id: params[:province_id])
              else
                City.none
              end
debugger
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("city_select", partial: "cities/city_options", locals: { cities: @cities }) }
    end
  end

  def province 
    @cities = City.where(province_id: params[:id]).order(:city_name)
    render json: @cities.map { |city| { id: city.id, city_name: city.city_name } }
  end
end
