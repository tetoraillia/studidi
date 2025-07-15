class Response < ApplicationRecord
    belongs_to :lesson
    belongs_to :user
    belongs_to :mark, optional: true

    validates :content, presence: true
end
