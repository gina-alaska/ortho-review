class SourcesController < ApplicationController
  respond_to :html, :xml
  
  def index
    @sources = Source.order("date(created_at) DESC, name ASC")
    
    if params[:name].present?
      @sources = @sources.where('name ilike ?', "%#{params[:name]}%")
    end
    
    if params[:state].present?
      @sources = @sources.where('state = ?', params[:state])
    end
    
    respond_to do |format|
      format.html {
        @sources = @sources.paginate(:page => params[:page], :per_page => 30)
      }
      format.xml
      format.json
    end
  end
  
  def show
    @source = Source.find(params[:id])
    respond_with @source
  end

  def create
    @source = Source.new(source_params)
    note = params[:source].delete(:note)
    if @source.note.nil?
      @source.create_note(:text => note)
    else
      @source.note.update_attributes(:text => note)
    end
    @source.save!
 
    respond_to do |format|
      format.html { redirect_to root_path }
      format.xml { render :xml => @source }
      format.json { render :json => @source }
    end
  rescue ActiveRecord::RecordInvalid => e
    invalid(@source, e)
  end

  def update
    @source = Source.find(params[:id])
    note = params[:source].try(:delete, :note)
    if @source.note.nil?
      @source.create_note(:text => note)
    else
      @source.note.update_attributes(:text => note)
    end

    @source.update_attributes!(source_params)
    # TODO what happens when it blows up?

    respond_to do |format|
      format.html { redirect_to root_path }
      format.xml { render :xml => @source }
      format.json { render :json => @source }
    end
  rescue ActiveRecord::RecordInvalid => e
    invalid(@source, e)
  end

  def delete
    @source = Source.find(params[:id])
    @source.destroy
    
  end

  protected
  
  def source_params
    Rails.logger.info params.inspect
    params.require(:source).permit(:name, :state, :accepted_at, :rejected_at, :flagged_at)
  end
end
