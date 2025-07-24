module Topics
  class CreateTopic
    include Interactor

    def call
      topic = Topic.new(context.params)

      if topic.save
        context.topic = topic
      else
        context.fail!(error: topic.errors.full_messages.to_sentence)
      end
    end
  end
end
