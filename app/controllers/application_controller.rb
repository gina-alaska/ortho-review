class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  
  protected

  def invalid(object, e)
    respond_to do |format|
      format.xml { render :xml => object.errors, :status => 422 }
    end
  end
end
