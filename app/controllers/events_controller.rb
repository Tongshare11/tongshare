class EventsController < ApplicationController
	require "pp"
  # GET /events
  # GET /events.json
  # GET /events?lat=1.0&lng=1.0&r=1.0 
  def index
    if (params[:lat].blank? || params[:lng].blank? || params[:r].blank?)	  
      @events = Event.all
    else
			# get all the events in a square area from DB
			lat = params[:lat].to_f
			lng = params[:lng].to_f
			r = params[:r].to_f
			eventsList = Event.where(:latitude => (lat - r)..(lat + r), :longitude => (lng - r)..(lng + r))
			# get all the events in a circle
			@events = []
		 	eventsList.each do |event|
			  dist = (event.latitude - lat) * (event.latitude - lat) + (event.longitude - lng) * (event.longitude - lng)
				if (dist <= r * r)
					@events << event
				end	
			end
			# sort the list by distance from the center
			@events.sort! do |x, y|
				xDist = (x.latitude - lat) * (x.latitude - lat) + (x.longitude - lng) * (x.longitude - lng)
				yDist = (y.latitude - lat) * (y.latitude - lat) + (y.longitude - lng) * (y.longitude - lng) 
				xDist <=> yDist
			end	
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
		  
    @event = Event.new(params[:event])
    #varify the json object 
    if (!@event.content? or @event.content.nil? or 
        !@event.title? or @event.title.nil? or
        !@event.first? or @event.first.nil? or
        @event.latitude.nil? or @event.longitude.nil?)
       respond_to do |format|
        format.json{ render json: {errorCode: 1, errorDesc: "Invalid JSON object recieved"}, status: :uprocessable_entity }
       end
    else  
      respond_to do |format|
        if @event.save
          #update points count
          point = Point.where("title = ?", @event.first).first
          if !point.nil?
            point.count = point.count + 1
            point.save
          end
          #respond
          format.html { redirect_to @event, notice: 'Event was successfully created.' }
          format.json { render json: @event, status: :created, location: @event }
        else
          format.html { render action: "new" }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
end
