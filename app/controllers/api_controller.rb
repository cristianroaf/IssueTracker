class ApiController < ApplicationController
    protect_from_forgery with: :null_session
    
    
    def issues
        respond_to do |format|
        @issues = Issue.all

        Rails.logger.debug("ENTRA")
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
  
        format.json {render json: @issues, status: :ok}
      end
    end
    
    def newissue
      
      #------ ESTO SIRVE PARA DEBUGAR
      #Rails.logger.debug("PARAMS: #{issue_params}")
      #Rails.logger.debug("API-KEY: #{api_key}")
      #Rails.logger.debug("USER: #{user.inspect}")
      #Rails.logger.debug("PARAMS: #{params.inspect}")
      
      #HAY QUE BORRAR EL PARAMETRO DE API KEY EN EL MOMENTO QUE SE LEE PORQUE NO ES UN PARAMETRO VALIDO CUANDO SE CREA UNA ISSUE
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
        @issue = Issue.new(issue_params)
        @issue.user_id = user.id
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
    
    def issue_params
      params.permit(:Title, :Description, :Type, :Priority, :Status, :asignee_id, :user_id, :attachment)
    end
    
end