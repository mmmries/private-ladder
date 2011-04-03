class PlayersController < ApplicationController
  # GET /players
  # GET /players.xml
  def index
    @players = Player.asc(:name)
    
    puts @players.to_json( :methods => [:gravatar] )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @players.to_json( :methods => [:hash], :except => [:password] ) }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @players.to_json( :methods => [:hash], :except => [:password] ) }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    unless get_login.nil? then
      raise 'logged in users cannot add additional players'
    end
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to(login_path, :notice => 'You have successfully registered. Please login below.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to(@player, :notice => 'Player was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
    end
  end
end
