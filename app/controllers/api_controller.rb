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
        format.json{ render json: payload, :status => 401 }
      else
        @issue = Issue.new(issue_params)
        @issue.user_id = user.id
        @issue.Status = "New"
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
        @userAssigned = User.where(["id = ?",@issue.asignee_id]).first
        userAssignedName = nil
        if !@userAssigned.nil?
          userAssignedName = @userAssigned.name
        end
        response = {
          :issue => @issue,
          :userCreatorName => user.name,
          :userAssignedName => userAssignedName
        }
        format.json { render :json => response, status: :ok }
        
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
    
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      render :json => payload, :status => 401
    else
      issue = Issue.where("id = ?", params[:issue_id]).first
      if issue.nil?
        payload = {
        error: "There is no issue such with id; please visit /issues",
        status: 422
        }
        render :json => payload, :status => 422
      
      else
        voto = Vote.where("issue_id = ? and user_id = ?", params[:issue_id], user.id).first
        if voto.nil?
          @vote = Vote.new(vote_params)
          @vote.user_id = user.id
          respond_to do |format|
            if @vote.save
              issue.increment!("Votes")
              Rails.logger.debug("Issue: #{issue.inspect}")
              format.json { render json: @vote, status: :created }
            else
              format.json { render json: @vote.errors, status: :unprocessable_entity }
            end
          end
        else
          payload = {
          error: "there is already a user vote on the issue",
          status: 422
          }
          render :json => payload, :status => 422
        end
      end
    end
  end
  
  def unvote
    
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      render :json => payload, :status => 401
    else
      issue = Issue.where("id = ?", params[:issue_id]).first
      if issue.nil?
        payload = {
        error: "There is no issue such with id; please visit /issues",
        status: 422
        }
        render :json => payload, :status => 422
      
      else
        voto = Vote.where("issue_id = ? and user_id = ?", params[:issue_id], user.id).first
        if voto.nil?
          payload = {
          error: "there is no a user vote on the issue",
          status: 422
          }
          render :json => payload, :status => 422
        else
          @vote = Vote.where("issue_id = ? and user_id = ?", params[:issue_id], user.id).first
          @vote.destroy
          @vote = Vote.where("issue_id = ? and user_id = ?", params[:issue_id], user.id).first
          respond_to do |format|
            if @vote.nil?
              issue.decrement!("Votes")
              Rails.logger.debug("Issue: #{issue.inspect}")
              format.json {render json: {"Correcto":"voto eliminado"}, status: :ok}
            else
              format.json { render json: @vote.errors, status: :unprocessable_entity }
            end
          end
        end
      end
    end
  end
  
  def watch
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      render :json => payload, :status => 401
    else
      issue = Issue.where("id = ?", params[:issue_id]).first
      if issue.nil?
        payload = {
        error: "There is no issue such with id; please visit /issues",
        status: 422
        }
        render :json => payload, :status => 422
      
      else
        watch = Watcher.where("issue_id = ? and user_id = ?", params[:issue_id], user.id).first
        if watch.nil?
          @watcher = Watcher.new(watcher_params)
          @watcher.user_id = user.id
          respond_to do |format|
            if @watcher.save
              issue.increment!("Watchers")
              Rails.logger.debug("Issue: #{issue.inspect}")
              format.json { render json: @watcher, status: :created }
            else
              format.json { render json: @watcher.errors, status: :unprocessable_entity }
            end
          end
        else
          payload = {
          error: "there is already a user watch on the issue",
          status: 422
          }
          render :json => payload, :status => 422
        end
      end
    end
  end
  
  def unwatch
    
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      render :json => payload, :status => 401
    else
      issue = Issue.where("id = ?", params[:issue_id]).first
      if issue.nil?
        payload = {
        error: "There is no issue such with id; please visit /issues",
        status: 422
        }
        render :json => payload, :status => 422
      
      else
        watch = Watcher.where("issue_id = ? and user_id = ?", params[:issue_id], user.id).first
        if watch.nil?
          payload = {
          error: "there is no a user watch on the issue",
          status: 422
          }
          render :json => payload, :status => 422
        else
          @watcher = Watcher.where("issue_id = ? and user_id = ?", params[:issue_id], user.id).first
          @watcher.destroy
          @watcher = Watcher.where("issue_id = ? and user_id = ?", params[:issue_id], user.id).first
          respond_to do |format|
            if @watcher.nil?
              issue.decrement!("Watchers")
              Rails.logger.debug("Issue: #{issue.inspect}")
              format.json {render json: {"Correcto":"watcher eliminado"}, status: :ok}
            else
              format.json { render json: @watcher.errors, status: :unprocessable_entity }
            end
          end
        end
      end
    end
  end
  

  
  def getcomments
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      render :json => payload, :status => 401
    else
      @issue = Issue.where("id = ?",params[:issue_id]).first

      if @issue.nil?
        payload = {
          error: "There is no issue with such issue_id",
          status: 404 
        }
        render :json => payload, :status => 404
      else

        comments = @issue.comments
        respond_to do |format|
          format.json {render json: comments, status: :ok}
        end
      end
    end 
  end


  def newcomment
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      render :json => payload, :status => 401
    else
      @issue = Issue.where("id = ?",params[:issue_id]).first

      if @issue.nil?
        payload = {
          error: "There is no issue with such issue_id",
          status: 404 
        }
        render :json => payload, :status => 404
      else

        @comment = Comment.new(comment_params)
        @comment.issue_id = @issue.id
        @comment.user_id = user.id
        @comment.save
        respond_to do |format|
          format.json {render json: @comment, status: :created}
        end
      end
   
    end
  end


  def getcomment

    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      render :json => payload, :status => 401
    else
      @issue = Issue.where("id = ?",params[:issue_id]).first

      if @issue.nil?
        payload = {
          error: "There is no issue with such issue_id",
          status: 404 
        }
        render :json => payload, :status => 404
      else

        @comment = @issue.comments.where("id = ?",params[:id]).first

        if @comment.nil?
          payload = {
            error: "There is no comment with such id in this issue",
            status: 404 
          }
          render :json => payload, :status => 404
        else
          respond_to do |format|
            format.json {render json: @comment, status: :ok}
          end
        end
      end
    end
  end


  def editcomment
    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      render :json => payload, :status => 401
    else
      @issue = Issue.where("id = ?",params[:issue_id]).first

      if @issue.nil?
        payload = {
          error: "There is no issue with such issue_id",
          status: 404 
        }
        render :json => payload, :status => 404
      else

        @comment = @issue.comments.where("id = ?",params[:id]).first

        if @comment.nil?
          payload = {
            error: "There is no comment with such id in this issue",
            status: 404 
          }
          render :json => payload, :status => 404
        else
          respond_to do |format|
            if @comment.user_id == user.id
              @comment.text = comment_params[:text]
              @comment.save
                format.json {render json: @comment, status: :ok}
            else
                format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
            end
          end
        end
      end
    end
  end



  def deletecomment 

    api_key = params[:api_key]
    params.delete :api_key
    user = User.where(["authentication_token = ?", api_key]).first

    if user.nil?
      # No existe usuario con ese token
      payload = {
        error: "There is no user with such api_key; please visit /users",
        status: 401 
      }
      render :json => payload, :status => 401
    else
      @issue = Issue.where("id = ?",params[:issue_id]).first

      if @issue.nil?
        payload = {
          error: "There is no issue with such issue_id",
          status: 404 
        }
        render :json => payload, :status => 404
      else

        @comment = @issue.comments.where("id = ?",params[:id]).first

        if @comment.nil?
          payload = {
            error: "There is no comment with such id in this issue",
            status: 404 
          }
          render :json => payload, :status => 404
        else

          if @comment.user_id == user.id
            @comment.destroy
          end
          respond_to do |format|
            if @comment.user_id == user.id
              payload = {
                message: "Comment deleted",
                status: 200 
              }
              format.json {render :json => payload, status: :ok}
            else
              format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
            end
          end
        end
      end
    end
  end
    
    
  def issue_params
    params.permit(:Title, :Description, :Type, :Priority, :Status, :asignee_id, :user_id, :attachment)
  end
  
  def vote_params
    params.permit(:user_id, :issue_id)
  end
  
  def watcher_params
    params.permit(:user_id, :issue_id)
  end
  
  def comment_params
    params.permit(:text, :attachment, :user_id, :issue_id, :id)
  end

    
end