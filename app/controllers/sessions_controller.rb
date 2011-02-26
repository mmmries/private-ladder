class SessionsController < ApplicationController
  # GET /sessions/new - login screen
  def new
    @session = Session.new

    respond_to do |format|
      format.html # new.html.haml
    end
  end

  # POST /sessions #login
  def create
    @session = Session.new(params[:session])

    
  end

  # DELETE /sessions/1 - #logout
  def destroy
    
  end
end
