class LeaguesController < ApplicationController
  # GET /leagues
  # GET /leagues.xml
  def index
    @leagues = League.asc(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @leagues }
    end
  end

  # GET /leagues/1
  # GET /leagues/1.xml
  def show
    @league = League.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @league }
    end
  end

  # GET /leagues/new
  # GET /leagues/new.xml
  def new
    if get_login.nil? then
      raise 'only logged in users can create new leagues'
    end
    @league = League.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @league }
    end
  end

  # GET /leagues/1/edit
  def edit
    unless is_admin? then
      raise 'Only admins can edit leagues'
    end
    @league = League.find(params[:id])
  end

  # POST /leagues
  # POST /leagues.xml
  def create
    if get_login.nil? then
      raise 'only logged in users can create new leagues'
    end
    
    @league = League.new(params[:league])

    respond_to do |format|
      if @league.save
        format.html { redirect_to(@league, :notice => 'League was successfully created.') }
        format.xml  { render :xml => @league, :status => :created, :location => @league }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @league.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /leagues/1
  # PUT /leagues/1.xml
  def update
    unless is_admin? then
      raise 'admins only'
    end
    @league = League.find(params[:id])

    respond_to do |format|
      if @league.update_attributes(params[:league])
        format.html { redirect_to(@league, :notice => 'League was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @league.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.xml
  def destroy
    unless is_admin? then
      raise 'admins only'
    end
    @league = League.find(params[:id])
    @league.destroy

    respond_to do |format|
      format.html { redirect_to(leagues_url) }
      format.xml  { head :ok }
    end
  end
  
  ## GET /leagues/:id/join
  def join
    if get_login.nil? then
      raise 'only logged in users can join leagues'
    end
    
    league = League.find(params[:id])
    if league.nil? then
      raise 'non existent league'
    end
    
    if get_login.in_league?(league["_id"]) then
      raise "you are already in the #{league.name} league"
    end
    
    get_login.leagues << league["_id"]
    get_login.save!
    
    redirect_to :controller => "leagues", :action => "index"
  end
  
  ## GET /leagues/:id/join
  def leave
    if get_login.nil? then
      raise 'only logged in users can leave leagues'
    end
    
    league = League.find(params[:id])
    if league.nil? then
      raise 'non existent league'
    end
    
    unless get_login.in_league?(league["_id"]) then
      raise "you are not in the #{league.name} league"
    end
    
    get_login.leagues.delete_if do |lid|
      lid == league["_id"]
    end
    get_login.save!
    
    redirect_to :controller => "leagues", :action => "index"
  end
end
