class MarkersController < ApplicationController

  # GET /markers
  # GET /markers.json
  def index
    @markers = Marker.find(:all, :order => "num_referred desc, created_at desc")
  end

  # GET /markers/1
  # GET /markers/1.json
  def show
    if Marker.check_code_exists(params[:code])
      @share = {
        :url => "http://beginnings.wearebrightly.com/join/#{params[:code]}",
        :name => "Join the Beginnings & Endings project",
        :caption => "Brightly",
        :picture => "http://beginnings.wearebrightly.com/apple-touch-icon.png",
        :description => "We are Brightly, a band in Melbourne. We are giving our album away, free. Sign up with this link to get our new single free, and your friend one step closer to the album. Huzzah!",
        :redirect_uri => "http://beginnings.wearebrightly.com/map/#{params[:code]}",
        :tweet => "Join the Beginnings & Endings project using my code and get @wearebrightly's debut album free.",
        :related => "wearebrightly"
      }
      @marker = Marker.find_by_code(params[:code])
    else
      flash.now[:alert] = "Looks like that code doesn't exist? Doesn't matter, you can still sign up!"
      redirect_to "/map", notice: "We couldn't find that code? Awkward..."
    end
  end

  # GET /markers/new
  # GET /markers/new.json
  def new
    if Download.has_no_singles
      redirect_to "/ohno"
    end

    if params[:code]
      unless Marker.check_code_exists(params[:code])
        params[:code] = ""
        flash.now[:alert] = "Looks like that code doesn't exist? Doesn't matter, you can still sign up!"
      end
      @page_title = "Code #{params[:code]} | Join The Beginnings & Endings Project"
      @facebook_meta_title = "Code #{params[:code]} | Join The Beginnings & Endings Project"
    end

    @marker = Marker.new
  end

  def oh_no

  end

  # POST /markers
  # POST /markers.json
  def create
    @marker = Marker.new(params[:marker])

    if @marker.save
      referrer_code = params[:marker][:referrer_code]
      MailingList.add_subscriber @marker if @marker.is_subscriber?
      redirect_to "/thanks/#{@marker.code}", notice: 'Marker was successfully created.'
    else
      render action: "new"
    end
  end
end
