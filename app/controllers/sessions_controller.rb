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
    res = Player.first( :conditions => {:name => @session.username})
    if res.nil? or res.password != @session.password then
      @session.errors.add :username, "the username/password supplied does not match any known user"
      respond_to do |format|
        format.html { render :action => "new" }
      end
    else
      session[:login] = res.id
      params[:id] = res.id
      redirect_to "/players/#{res.id}"
    end
  end

  # DELETE /sessions/1 - #logout
  def destroy
    unless session[:login].nil? then
      session[:login] = nil
    end
    redirect_to :controller => "leagues", :action => "index"
  end
end
