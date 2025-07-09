class Invitations::InvitationCreator
    CODE_USER_NOT_FOUND = :user_not_found
    CODE_USER_ALREADY_ENROLLED = :user_already_enrolled
    CODE_INVITATION_ALREADY_EXISTS = :invitation_already_exists
    CODE_INVITATION_ALREADY_ACCEPTED = :invitation_already_accepted
    CODE_VALIDATION_FAILED = :validation_failed

    def initialize(current_user:, email:, course:)
        @user = current_user
        @invited_email = email
        @course = course
    end

    def call
        return user_not_found_result if user_not_found?
        return user_already_enrolled_result if Enrollment.exists?(user: User.find_by(email: @invited_email), course: @course)
        return invitation_already_exists_result if invitation_already_exists?

        invitation = @course.invitations.build(email: @invited_email, invited_by: @user)
        send_invitation_email(invitation)
    end

    private

    def send_invitation_email(invitation)
        if invitation.save
            InvitationMailer.invite_email(invitation).deliver_later
            Result.new(success: true, data: invitation)
        else
            Result.new(success: false, error_code: CODE_VALIDATION_FAILED, message: invitation.errors.full_messages.to_sentence)
        end
    end

    def user_not_found?
        user = User.find_by(email: @invited_email)
        user.nil?
    end

    def invitation_already_exists?
        Invitation.exists?(course: @course, email: @invited_email, status: "pending")
    end

    def user_not_found_result
        Result.new(success: false, error_code: CODE_USER_NOT_FOUND, message: "User with email #{@invited_email} not found.")
    end

    def invitation_already_exists_result
        invitation = Invitation.find_by(course: @course, email: @invited_email, status: "pending")

        if invitation.status == "accepted"
            Result.new(success: false, error_code: CODE_INVITATION_ALREADY_ACCEPTED, message: "This user has already accepted the invitation.")
        else
            Result.new(success: false, error_code: CODE_INVITATION_ALREADY_EXISTS, message: "An invitation has already been sent and is pending.")
        end
    end

    def user_already_enrolled_result
        Result.new(success: false, error_code: CODE_USER_ALREADY_ENROLLED, message: "User is already enrolled in this course.")
    end
end
