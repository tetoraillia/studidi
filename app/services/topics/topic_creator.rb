module Topics
    class TopicCreator
        def initialize(topic_params)
            @topic_params = topic_params
        end

        def call
            topic = Topic.new(@topic_params)
            if topic.save
                Result.success(topic)
            else
                Result.failure(topic.errors)
            end
        end
    end
end
