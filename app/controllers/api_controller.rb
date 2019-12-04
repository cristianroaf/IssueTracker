class ApiController < ApplicationController
  protect_from_forgery with: :null_session
    

  def issues
    
    respond_to do |format|
    
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first
    
    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      format.json {render :json => payload, :status => 401}
      
    else
      
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
      if params.has_key?(:watcher)
        if User.exists?(id: params[:watcher])
          @issues = Issue.joins(:watchers).where(watchers:{user_id: params[:watcher]})
        else
          format.json {render json: {"error":"User with id="+params[:watcher]+" does not exist"}, status: :unprocessable_entity}
        end
      end
  
      format.json {render json: @issues, status: :ok}
    end
    end
  end
  
  def newissue
    
    #------ ESTO SIRVE PARA DEBUGAR
    #Rails.logger.debug("PARAMS: #{params.inspect}")
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      format.json{ render :json => payload, :status => 401 }
    else
      @issue = Issue.new(issue_params)
      @issue.user_id = user.id
      @issue.Status = "New"
      respond_to do |format|
        if (issue_params.has_key?(:asignee_id) && issue_params[:asignee_id] != "" && !User.exists?(id: issue_params[:asignee_id]))
            format.json {render json: {"error":"User with id="+issue_params[:asignee_id]+" does not exist"}, status: :unprocessable_entity}
        else
          if @issue.save
            @watcher = Watcher.new
            @watcher.user_id = user.id
            @watcher.issue_id = @issue.id
            @watcher.save
            @issue.increment!("Watchers")
            format.json { render json: @issue, status: :created}
          else
            format.json { render json: @issue.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end
  
  def editstatus
    respond_to do |format|
      
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first
    
    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      format.json {render :json => payload, :status => 401}
      
    else      
      issue = Issue.where("id = ?", params[:issue_id]).first
      if issue.nil?
        payload = {
          error: "There is no issue such with id; please visit /issues",
          status: 422
        }
        format.json{ render :json => payload, :status => 422 }
      elsif issue.user_id.to_s != user.id.to_s
        payload = {
          error: "The issue does not belong to the user with such api_key",
          status: 403
        }
        format.json{ render :json => payload, :status => 403 }
      else
        issue.update_attribute("Status", params[:Status])
        format.json { render json: issue, status: :ok }
      end
    end
    end
  end
  
  def getissue
    respond_to do |format|
      api_key = params[:api_key]
      params.delete :api_key
      user = User.where(["authentication_token = ?", api_key]).first
      @issue = Issue.where(["id = ?", params[:issue_id]]).first
      if user.nil?
        # No existe usuario con ese token
        payload = {
          error: "There is no user with such api_key; please visit /users",
          status: 401 
        }
        format.json {render :json => payload, :status => 401}
      elsif  @issue.nil?
        payload = {
          error: "There is no issue such with id; please visit /issues",
          status: 422
        }
        format.json{ render :json => payload, :status => 422 }        
      else
         format.json { render json: @issue, status: :ok }
      end
    end
  end
  
  def editissue

    respond_to do |format|
      
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first
    
    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      format.json {render :json => payload, :status => 401}
      
    else      
      issue = Issue.where("id = ?", params[:issue_id]).first
      Rails.logger.debug("#{issue.inspect}")
      if issue.nil?
        payload = {
          error: "There is no issue such with id; please visit /issues",
          status: 422
        }
        format.json{ render :json => payload, :status => 422 }
      elsif issue.user_id.to_s != user.id.to_s
        payload = {
          error: "The issue does not belong to the user with such api_key",
          status: 403
        }
        format.json{ render :json => payload, :status => 403 }
      else
        params.delete :issue_id
        if issue.update(issue_params.merge(:Status => issue.Status))
          format.json { render json: issue, status: :ok}
        else
          format.json { render json: issue.errors, status: :unprocessable_entity }
        end
      end
    end    
    end
  end

  def deleteissue
    respond_to do |format|
    Rails.logger.debug("ENTRA")
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first
    
    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      format.json {render :json => payload, :status => 401}
      
    else      
      @issue = Issue.where("id = ?", params[:issue_id]).first
      if @issue.nil?
        payload = {
          error: "There is no issue such with id; please visit /issues",
          status: 422
        }
        format.json{ render :json => payload, :status => 422 }
      elsif @issue.user_id.to_s != user.id.to_s
        payload = {
          error: "The issue does not belong to the user with such api_key",
          status: 403
        }
        format.json{ render :json => payload, :status => 403 }
      else
        if @issue.destroy
          payload = {
            message: "Successfully deleted issue",
            status: 200
          }
        format.json{ render :json => payload, :status => 200 }
        else
          format.json { render json: @issue.errors, status: :unprocessable_entity }
        end
      end
    end    
    end    
  end
  
  def vote
  end
  def unvote
  end
  def watch
  end
  def unwatch
  end
  

  
  def getcomments
  end
  def newcomment
  end
  
  def getcomment
  end
  def editcomment
  end
  def deletecomment
  end
    
    
  def issue_params
    params.permit(:Title, :Description, :Type, :Priority, :Status, :asignee_id, :user_id, :attachment)
  end
    
end