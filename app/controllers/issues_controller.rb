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
          @issues = Issue.all.order('Votes asc')
        elsif params[:sort] == "priority"
          @issues = Issue.all.order('Priority asc')
        elsif params[:sort] == "kind"
          @issues = Issue.all.order('Type desc')
        elsif params[:sort] == "status"
          @issues = Issue.all.order('Status asc')
        elsif params[:sort] == "assignee"
        elsif params[:sort] == "created"
          @issues = Issue.all.order('created_at desc')
        elsif params[:sort] == "updated"
          @issues = Issue.all.order('updated_at desc')
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

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
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

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'Issue was successfully destroyed.' }
      format.json { head :no_content }
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
