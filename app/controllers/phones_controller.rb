class PhonesController < ApplicationController
  include Resource
  skip_before_action :set_model, :set_resource

  def index
    urls = Gsmarena::Gsmarena.new(:pagination, params[:url]).parse
    @collection = Gsmarena::Gsmarena.new(:phones, urls).parse
    respond_to { |format| format.json { render json: index_respond_json } }
  end

  def show
    @resource = Gsmarena::Gsmarena.new(:phone, params[:url]).parse
    respond_to { |format| format.json { render json: show_render_json } }
  end

  private

  def index_respond_json
    { collection: @collection, msg: 'Список телефонов успешно загружен' }
  end

  def show_render_json
    { resource: @resource, msg: 'Информация о телефоне успешно загружена' }
  end
end
