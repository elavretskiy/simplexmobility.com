module Resource
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :rescue_render_json

    respond_to :json

    before_action :set_model
    before_action :set_path
    before_action :set_resource, only: [:show, :edit, :update, :destroy]

    def index
      index! { |format| format.json { render json: index_respond_json } }
    end

    def show
      show! { |format| format.json { render json: show_render_json } }
    end

    def new
      new!
    end

    def edit
      edit!
    end

    def create
      @resource = @model.new
      @resource.assign_attributes resource_params
      create! { |success, failure| create_respond_json(success, failure) }
    end

    def update
      if @resource.update(resource_params)
        success_update_render_json
      else
        failure_render_json
      end
    end

    def destroy
      destroy! { |format| destroy_respond_json(format) }
    end

    private

    def set_resource
      @resource = @model.find(params[:id])
    end

    def set_path; end

    def create_respond_json(success, failure)
      success.json { success_create_render_json }
      failure.json { failure_render_json }
    end

    def failure_render_json
      render json: { errors: @resource.errors }, status: 422
    end

    def index_respond_json
      {
        total_count: @collection.total_count,
        collection: index_render_json,
        page: params[:page] || 1,
        page_size: @collection.limit_value
      }
    end

    def index_render_json
      @collection
    end

    def show_render_json
      @resource
    end

    def success_create_render_json
      success_render_json(success_created_message, success_create_redirect)
    end

    def success_update_render_json
      success_render_json(success_updated_messages, success_update_redirect)
    end

    def success_render_json(msg, redirect_to)
      render json: { "#{model_name}": @resource, msg: msg, redirect_to: redirect_to }
    end

    def destroy_respond_json(format)
      format.json { success_render_json(success_destroyed_message,
                                        success_destroy_redirect) }
    end

    def success_updated_messages
      t('activerecord.successful.messages.created')
    end

    def success_created_message
      t('activerecord.successful.messages.created')
    end

    def success_destroyed_message
      t('activerecord.successful.messages.destroyed')
    end

    def success_update_redirect
      "#{model_name.pluralize(3)}_path"
    end

    def success_create_redirect
      "#{model_name.pluralize(3)}_path"
    end

    def success_destroy_redirect
      "#{model_name.pluralize(3)}_path"
    end

    def model_name
      @model.model_name.to_s.underscore
    end

    def rescue_render_json(e, msg = nil)
      error = 'Ошибка сервера. Повторите попытку'
      render json: { msg: msg || error }, status: 422
      ExceptionNotifier.notify_exception(e, env: request.env, data: { message: msg || error })
    end
  end
end
