class Invitations::InvitationAcceptor
    CODE_NOT_SIGNED_IN = :not_signed_in
    CODE_INVITATION_INVALID = :invalid_invitation
    CODE_ALREADY_ENROLLED = :already_enrolled
    
    def initialize(invitation:, current_user:, course:)
        @invitation = invitation
        @user = current_user
        @course = course
    end

    def call
        return invalid_invitation_result if invalid_invitation?
        return not_signed_in_result if user_not_signed_in?
        return already_enrolled_result if already_enrolled?

        enroll_user
        mark_invitation_as_accepted

        Result.new(success: true, data: @invitation)
    end

    private

    def invalid_invitation?
        @invitation.nil? || @invitation.status != "pending" || @invitation.course != @course
    end

    def user_not_signed_in?
        @user.nil?
    end

    def already_enrolled?
        @user.enrolled_in?(@course)
    end

    def enroll_user
        Enrollment.create(user: @user, course: @course, enrolled_at: Time.current)
    end

    def mark_invitation_as_accepted
        @invitation.update(status: "accepted")
    end

    def invalid_invitation_result
        Result.new(success: false, error_code: CODE_INVITATION_INVALID, message: "Invalid or expired invitation.")
    end

    def not_signed_in_result
        Result.new(success: false, error_code: CODE_NOT_SIGNED_IN, message: "Please sign in to accept the invitation.")
    end

    def already_enrolled_result
        Result.new(success: false, error_code: CODE_ALREADY_ENROLLED, message: "You are already enrolled in this course.")
    end
end
