class PreviewsController < ApplicationController
  def show
    s = Source.where(name: params[:id]).first
    
    send_file s.preview, disposition: 'inline'
  end
end
