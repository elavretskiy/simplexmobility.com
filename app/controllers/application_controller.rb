class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  inherit_resources

  layout proc {
    if request.xhr?
      'content_wrapper'
    else
      'admin_lte_2'
    end
  }
end
