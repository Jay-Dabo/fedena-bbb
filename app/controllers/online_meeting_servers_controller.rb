class OnlineMeetingServersController < ApplicationController
  filter_access_to :all

  def index
    @servers = OnlineMeetingServer.all
  end

  def show
    @server = OnlineMeetingServer.find(params[:id])
  end

  def new
   @server = OnlineMeetingServer.new
  end

  def edit
   @server = OnlineMeetingServer.find_by_id(params[:id])
  end

  def activity
    @server = OnlineMeetingServer.find_by_id(params[:id])
    # @new_meetings = @server.rooms
    @server.fetch_meetings
    # @new_meetings = @server.meetings.reject{ |r|
    #  i = @new_meetings.index(r)
    #  i.nil? ? false : r.attr_equal?(@new_meetings[i])
    #}
    @server.meetings.each do |meeting|
      meeting.fetch_meeting_info
    end

    # TODO catch exceptions

    if params[:update_list]
      render :partial => 'activity_list'
      return
    end

    # TODO json response

    @server
  end

  def create
    @server = OnlineMeetingServer.new(params[:online_meeting_server])

    respond_to  do |format|
      if @server.save
        format.html {
          flash[:notice] = t('online_meeting_server_created_successfully')
          redirect_to(online_meeting_servers_path)
        }
        format.json { render :json => @server, :status => :created }
      else
        format.html { render :action => "new" }
        format.json { render :json => @server.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @server = OnlineMeetingServer.find_by_id(params[:id])

    respond_to  do |format|
      if @server.update_attributes(params[:online_meeting_server])
        format.html {
          flash[:notice] = t('online_meeting_server_updated_successfully')
          redirect_to(online_meeting_servers_path)
        }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @server.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @server = OnlineMeetingServer.find_by_id(params[:id])
    @server.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = t('online_meeting_server_destroyed_successfully')
        redirect_to(online_meeting_servers_url) }
      format.json { head :ok }
    end
  end
end