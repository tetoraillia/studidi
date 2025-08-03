module Bookmarks
  class CreateBookmark
    include Interactor

    before :validate_params
    before :check_bookmark_exists

    def call
      bookmark = Bookmark.new(user_id: context.user_id, course_id: context.course_id)
      if bookmark.save
        context.bookmark = bookmark
        context.course = Course.find(context.course_id)
      else
        context.fail!(message: "Failed to create bookmark")
        context.course = Course.find(context.course_id)
      end
    end

    private

      def validate_params
        context.fail!(message: "Missing user_id or course_id") unless context.user_id && context.course_id
      end

      def check_bookmark_exists
        existing_bookmark = Bookmark.find_by(user_id: context.user_id, course_id: context.course_id)
        context.fail!(message: "You have already bookmarked this course") if existing_bookmark
      end
  end
end
