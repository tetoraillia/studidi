module Topics
    class TopicUpdater
        def initialize(id, params)
            @id = id
            @params = params
        end

        def call
            topic = Topic.find(@id)
            if topic.update(@params)
                Result.success(topic)
            else
                Result.failure(topic.errors)
            end
        end
    end
end
