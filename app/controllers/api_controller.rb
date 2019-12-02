class ApiController < ApplicationController
    
    def issues
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
        #if params[:sort] == "votes"
        # @issues = @issues.order('votes asc')
        #elsif params[:sort] == "priority"
        # @issues = @issues.order('priority asc')
        #elsif params[:sort] == "kind"
        # @issues = @issues.order('type asc')
        #elsif params[:sort] == "status"
        # @issues = @issues.order('status asc')
        if params[:sort] == "assignee"
          @issues = @issues.order('asignee_id asc')
        elsif params[:sort] == "created"
          @issues = @issues.order('created_at asc')
        elsif params[:sort] == "updated"
          @issues = @issues.order('updated_at asc')
        elsif params[:sort] == "Title"
          @issues = @issues.order('id asc')
        #elsif params[:sort] == "-votes"
        # @issues = @issues.order('votes desc')
        #elsif params[:sort] == "-priority"
        # @issues = @issues.order('priority desc')
        #elsif params[:sort] == "-kind"
        # @issues = @issues.order('type desc')
        #elsif params[:sort] == "-status"
        # @issues = @issues.order('status desc')
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

      format.json {render json: @issues, status: :ok}
    end
    end
end