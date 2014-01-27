class SourcesController < ApplicationController
  respond_to :html, :xml
  
  def index
    @sources = Source
    
    if params[:name].present?
      @sources = @sources.where('name ilike ?', "%#{params[:name]}%")
    end
    
    if params[:state].present?
      @sources = @sources.where('state = ?', params[:state])
    end
    
    if params[:start_date].present? and params[:end_date].present?
      #we have both do between
      s = DateTime.parse(params[:start_date]).beginning_of_day
      e = DateTime.parse(params[:end_date]).end_of_day
      
      @sources = @sources.where(created_at: (s..e))
    else
      #only one date figure out which one we have
      if params[:start_date].present?
        s = DateTime.parse(params[:start_date]).beginning_of_day      
        @sources = @sources.where('created_at > ?', s)
      end
      if params[:end_date].present?
        e = DateTime.parse(params[:end_date]).end_of_day
        @sources = @sources.where('created_at < ?', e)
      end
      
    end
    
    @total_found = @sources.count
    states_results = @sources.select("state, count(*) as state_count").group('state')
    @states = states_results.map { |s| [s.state, s.state_count] }
    
    @sources = @sources.order("date(created_at) DESC, name ASC")
    
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
