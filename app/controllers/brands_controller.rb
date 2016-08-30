class BrandsController < ApplicationController
  include Resource

  defaults resource_class: Brand, collection_name: 'collection', instance_name: 'resource'

  def create
    Gsmarena::Gsmarena.new(:brands).parse
    collection
    success_create_render_json
  end

  protected

  def collection
    get_collection_ivar || set_collection_ivar(apply_scopes(end_of_association_chain).index)
  end

  private

  def set_model
    @model = Brand
  end

  def index_respond_json
    { collection: @collection }
  end

  def success_render_json(msg, redirect_to)
    msg = 'Список брендов успешно обновлен'
    render json: { collection: @collection, msg: msg }
  end
end
