class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    unless is_admin? then
      raise 'only admins can access the game list'  
    end
    
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new(params[:game])
    @players = Player.any_of(:league_ids => @game.league_id)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:game])
    @game.participants.each do | part |
      part.points = 1.0 if part.result == "win"
      part.points = -0.5 if part.result == "lose"
      part.points ||= 0.0
      part.player = Player.find(part.player.id)
    end
    respond_to do |format|
      if @game.save
        format.html { redirect_to(@game.league, :notice => 'Game was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        @players = Player.any_of(:league_ids => @game.league_id)
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    unless is_admin? then
      raise 'only admins can delete games'
    end
    
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end
end
