class SourcesController < ApplicationController
  respond_to :html
  
  def index
    @sources = Source.order("date(created_at) DESC, name ASC").paginate(:page => params[:page], :per_page => 30)
    
    if params[:name].present?
      @sources = @sources.where('name ilike ?', "%#{params[:name]}%")
    end
    
    respond_with @sources
  end
end
