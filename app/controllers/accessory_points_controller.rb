class AccessoryPointsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy, :update ]
  # GET /accessory_points
  # GET /accessory_points.json
  def index
		if (params[:point_id].blank?)
    	@accessory_points = AccessoryPoint.all
		else
			@accessory_points = AccessoryPoint.where(:point_id => params[:point_id])
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accessory_points }
    end
  end

  # GET /accessory_points/1
  # GET /accessory_points/1.json
  def show
    @accessory_point = AccessoryPoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @accessory_point }
    end
  end

  # GET /accessory_points/new
  # GET /accessory_points/new.json
  def new
    @accessory_point = AccessoryPoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accessory_point }
    end
  end

  # GET /accessory_points/1/edit
  def edit
    @accessory_point = AccessoryPoint.find(params[:id])
  end

  # POST /accessory_points
  # POST /accessory_points.json
  def create
    @accessory_point = AccessoryPoint.new(params[:accessory_point])

    respond_to do |format|
      if @accessory_point.save
        format.html { redirect_to @accessory_point, notice: 'Accessory point was successfully created.' }
        format.json { render json: @accessory_point, status: :created, location: @accessory_point }
      else
        format.html { render action: "new" }
        format.json { render json: @accessory_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accessory_points/1
  # PUT /accessory_points/1.json
  def update
    @accessory_point = AccessoryPoint.find(params[:id])

    respond_to do |format|
      if @accessory_point.update_attributes(params[:accessory_point])
        format.html { redirect_to @accessory_point, notice: 'Accessory point was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @accessory_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accessory_points/1
  # DELETE /accessory_points/1.json
  def destroy
    @accessory_point = AccessoryPoint.find(params[:id])
    @accessory_point.destroy

    respond_to do |format|
      format.html { redirect_to accessory_points_url }
      format.json { head :ok }
    end
  end
 
private 
	def authenticate
		user = authenticate_with_http_basic do |username, password|
			users = User.where("username = ? AND password = ?", username, password)
			users[0]
		end
		if (not user.nil?)
			@user = user
			puts user
			return true
		
		else
			puts "********need auth********"
			request_http_basic_authentication
			return false

		end
	end

end

