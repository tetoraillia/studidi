class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarks = Bookmark.by_user(current_user).page(params[:page]).per(10)
  end

  def create
    result = Bookmarks::CreateBookmark.call(
        user_id: current_user.id,
        course_id: params[:course_id]
    )
    if result.success?
      redirect_to bookmarks_path(current_user), notice: result.message
    else
      redirect_to course_path(params[:course_id]), alert: result.message
    end
  end

  def destroy
    bookmark = Bookmark.find(params[:id])
    bookmark.destroy
    redirect_to bookmarks_path, notice: "Course unbookmarked successfully."
  end
end
