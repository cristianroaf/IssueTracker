class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /issues
  # GET /issues.json
  def index
    respond_to do |format|
      @issues = Issue.all
      
      if params.has_key?(:assignee)
        if User.exists?(id: params[:assignee])
          @issues = @issues.where(asignee_id: params[:assignee])
        else
          format.json {render json: {"error":"User with id="+params[:assignee]+" does not exist"}, status: :unprocessable_entity}
        end
      end
      
      if params.has_key?(:type)
        @issues = @issues.where(Type: params[:type])
      end
      
      if params.has_key?(:priority)
        @issues = @issues.where(Priority: params[:priority])
      end
      
      if params.has_key?(:status)
        if params[:status] == "New&Open"
          @issues = @issues.where(Status: ["Open","New"])
        else
        @issues = @issues.where(Status: params[:status])
        end
      end
      
      if params.has_key?(:watcher)
        if User.exists?(id: params[:watcher])
          @issues = Issue.joins(:watchers).where(watchers:{user_id: params[:watcher]})
        else
          format.json {render json: {"error":"User with id="+params[:watcher]+" does not exist"}, status: :unprocessable_entity}
        end
      end
      
      if params.has_key?(:sort)
        if params[:sort] == "votes"
         @issues = @issues.order('votes asc')
        elsif params[:sort] == "priority"
         @issues = @issues.order('priority asc')
        elsif params[:sort] == "kind"
         @issues = @issues.order('type asc')
        elsif params[:sort] == "status"
         @issues = @issues.order('status asc')
        elsif params[:sort] == "assignee"
          @issues = @issues.order('asignee_id asc')
        elsif params[:sort] == "created"
          @issues = @issues.order('created_at asc')
        elsif params[:sort] == "updated"
          @issues = @issues.order('updated_at asc')
        elsif params[:sort] == "Title"
          @issues = @issues.order('id asc')
        elsif params[:sort] == "-votes"
         @issues = @issues.order('votes desc')
        elsif params[:sort] == "-priority"
         @issues = @issues.order('priority desc')
        elsif params[:sort] == "-kind"
         @issues = @issues.order('type desc')
        elsif params[:sort] == "-status"
         @issues = @issues.order('status desc')
        elsif params[:sort] == "-assignee"
          @issues = @issues.order('asignee_id desc')
        elsif params[:sort] == "-created"
          @issues = @issues.order('created_at desc')
        elsif params[:sort] == "-updated"
          @issues = @issues.order('updated_at desc')
        elsif params[:sort] == "-Title"
          @issues = @issues.order('id desc')
        end
      end

      format.html
      format.json {render json: @issues, status: :ok, each_serializer: IssueIndexSerializer}
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)
    @issue.user_id = current_user.id
    respond_to do |format|
      if (issue_params.has_key?(:assignee_id) && issue_params[:assignee_id] != "" && !User.exists?(id: issue_params[:assignee_id]))
          format.json {render json: {"error":"User with id="+issue_params[:assignee_id]+" does not exist"}, status: :unprocessable_entity}
      else
        if @issue.save
          @watcher = Watcher.new
          @watcher.user_id = current_user.id
          @watcher.issue_id = @issue.id
          @watcher.save
          @issue.increment!("Watchers")
          format.html { redirect_to @issue }
          format.json { render json: @issue, status: :created, serializer: IssueSerializer }
        else
          format.html { render :new }
          format.json { render json: @issue.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_status
    respond_to do |format|
      @issue_to_update = Issue.find(params[:id])
      @issue_to_update.update_attribute("Status", params[:status])
      
      format.html { redirect_to @issue_to_update }
      format.json { render json: @issue_to_update, status: :ok }
    end
  end
  
  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'Issue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def vote
    respond_to do |format|
      @issue_to_vote = Issue.find(params[:id])
      if !Vote.exists?(:issue_id => @issue_to_vote.id, :user_id => current_user.id)
        @vote = Vote.new
        @vote.user_id = current_user.id
        @vote.issue_id = @issue_to_vote.id
        @vote.save
        @issue_to_vote.increment!("Votes")
      else
        @vote = Vote.where(issue_id: params[:id], user_id: current_user.id).take
        @vote.destroy
        @issue_to_vote.decrement!("Votes")
      end
      format.html { redirect_to @issue_to_vote }
      format.json { render json: @issue_to_vote, status: :ok }
    end
  end
  
  def watch
    respond_to do |format|
      @issue_to_watch = Issue.find(params[:id])
      if !Watcher.exists?(:issue_id => @issue_to_watch.id, :user_id => current_user.id)
        @watcher = Watcher.new
        @watcher.user_id = current_user.id
        @watcher.issue_id = @issue_to_watch.id
        @watcher.save
        @issue_to_watch.increment!("Watchers")
      else
        @watcher = Watcher.where(issue_id: params[:id], user_id: current_user.id).take
        @watcher.destroy
        @issue_to_watch.decrement!("Watchers")
      end
      if params[:view] == "index"
        format.html { redirect_to issues_url}
      else
        format.html { redirect_to @issue_to_watch}
      end
      format.json { render json: @issue_to_watch, status: :ok }
    end
  end
  
  def show_attachment
    @issue = Issue.find(params[:id])
    respond_to do |format|
      if @issue.attachment.file?
        format.json {render json: @issue, status: :ok, serializer: IssueattachmentSerializer}
      else
        format.json {render json: {}, status: :ok}
      end
    end
  end

  def create_attachment
    @issue = Issue.find(params[:id])
    if @issue.user.id == current_user.id
      @issue.attachment = Paperclip.io_adapters.for(params[:file])
      @issue.save
    end
    respond_to do |format|
      if @issue.user.id == current_user.id
        format.json {render json: @issue, status: :created, serializer: IssueattachmentSerializer}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this issue"}, status: :forbidden}
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:Title, :Description, :Type, :Priority, :Status, :user_id, :asignee_id, :Votes, :Watchers, :at_name, :at_format, :at_size, :at_updated_at)
    end
end