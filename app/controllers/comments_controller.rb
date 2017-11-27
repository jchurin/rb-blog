#
class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy]
  before_action :set_article
  before_action :authenticate_user!

  # POST /comments
  # POST /comments.json
  def create
    @comment = current_user.comments.new(comment_params)
    @comment.article = @article
    respond_to do |format|
      if @comment.save
        set_params_save(format, @comment.article, 'Comment was successfully created.', :show)
      else
        set_params_not_save(format, @comment.errors, 'Comment was successfully created.')
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment.article, notice: 'Comment was successfully updated.' }
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
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @article, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def comment_params
    params.require(:comment).permit(:user_id, :article_id, :body)
  end

  def set_params_save(format, redirect_param, notice_param, render_param = nil)
    format.html { redirect_to redirect_param, notice: notice_param }
    format.json { render render_param, status: :created, location: @comment }
  end

  def set_params_not_save(format, render_param, status_param)
    format.html { render :new }
    format.json { render json: render_param, status: status_param }
  end
end
