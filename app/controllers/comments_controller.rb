class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @issue = Issue.find(params[:issue_id])
    comments = @issue.comments
    respond_to do |format|
      format.json {render json: comments, status: :ok, each_serializer: CommentSerializer}
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    respond_to do |format|
      format.json {render json: @comment, status: :ok, each_serializer: CommentSerializer}
    end
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @issue = Issue.find(params[:issue_id])
    @comment.issue_id = @issue.id
    @comment.user_id = current_user.id
    @comment.save
    respond_to do |format|
      format.json {render json: @comment, status: :created, each_serializer: CommentSerializer}
      format.html {redirect_to issue_path(@issue)}
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.destroy
    end
    respond_to do |format|
      if @comment.user_id == current_user.id
        format.json {render json: {}, status: :ok}
        format.html {redirect_to issue_path(@issue)}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
      end
    end
  end

  def update
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.update(comment_params)
    end
    respond_to do |format|
      if @comment.user_id == current_user.id
        format.json {render json: @comment, status: :ok, each_serializer: CommentSerializer}
        format.html {redirect_to issue_path(@issue)}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
      end
    end
  end

  def show_attachment
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    respond_to do |format|
      if @comment.attachment.file?
        format.json {render json: @comment, status: :ok, serializer: AttachmentSerializer}
      else
        format.json {render json: {}, status: :ok}
      end
    end
  end

  def create_attachment
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.attachment = Paperclip.io_adapters.for(params[:file])
      @comment.save
    end
    respond_to do |format|
      if @comment.user_id == current_user.id
        format.json {render json: @comment, status: :created, serializer: AttachmentSerializer}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
      end        
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:text, :attachment, :user_id, :issue_id)
    end
end
