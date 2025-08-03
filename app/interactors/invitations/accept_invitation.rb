module Invitations
  class AcceptInvitation
    include Interactor

    CODE_NOT_SIGNED_IN = :not_signed_in
    CODE_INVITATION_INVALID = :invalid_invitation
    CODE_ALREADY_ENROLLED = :already_enrolled

    before :validate_context!

    def call
      return if context.failure?

      if invalid_invitation?
        context.fail!(error: "Invalid or expired invitation.", error_code: CODE_INVITATION_INVALID)
        return
      end

      if user_not_signed_in?
        context.fail!(error: "Please sign in to accept the invitation.", error_code: CODE_NOT_SIGNED_IN)
        return
      end

      if already_enrolled?
        context.fail!(error: "You are already enrolled in this course.", error_code: CODE_ALREADY_ENROLLED)
        return
      end

      ActiveRecord::Base.transaction do
        enroll_user
        mark_invitation_as_accepted
      end

      context.invitation = @invitation
    rescue StandardError => e
      context.fail!(error: "Failed to accept invitation: #{e.message}")
    end

    private

      def validate_context!
        if context.invitation.nil? || context.current_user.nil? || context.course.nil?
          context.fail!(error: "Invalid context: missing required parameters")
        end
      end

      def invalid_invitation?
        @invitation = context.invitation
        @course = context.course

        @invitation.nil? ||
          @invitation.status != "pending" ||
          @invitation.course != @course
      end

      def user_not_signed_in?
        @user = context.current_user
        @user.nil?
      end

      def already_enrolled?
        @user ||= context.current_user
        @course ||= context.course

        @user.enrolled_in?(@course)
      end

      def enroll_user
        Enrollment.create!(
          user: @user,
          course: @course,
          enrolled_at: Time.current
        )
      end

      def mark_invitation_as_accepted
        @invitation.update!(status: "accepted")
      end
  end
end
