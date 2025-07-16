module Invitations
    class CreateInvitation
        include Interactor

        before :validate_context!

        def call
            create_invitation

            if context.invitation.persisted?
                InvitationMailer.invite_email(context.invitation).deliver_now
                context.success
            else
                context.fail!(error: "Failed to create invitation.")
            end
        end

        private

        def validate_context!
            if context.params.nil? || context.course.nil? || context.current_user.nil?
                context.fail!(error: "Invalid context")
            end
        end

        def create_invitation
            context.invitation = Invitation.create(
                email: context.params[:email],
                course_id: context.course.id,
                invited_by_id: context.current_user.id
            )
        end
    end
end
