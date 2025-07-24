module Topics
  class UpdateTopic
    include Interactor

    def call
      topic = Topic.find(context.id)
      if topic.update(context.params)
        context.topic = topic
      else
        context.fail!(error: topic.errors.full_messages.to_sentence)
      end
    end
  end
end
