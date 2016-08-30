class SearchController < ApplicationController
  include Resource
  skip_before_action :set_model

  def index
    @collection = Gsmarena::Gsmarena.new(:search, params[:url]).parse
    respond_to { |format| format.json { render json: index_respond_json } }
  end

  private

  def index_respond_json
    { collection: @collection, msg: 'Поиск выполнен успешно' }
  end
end
