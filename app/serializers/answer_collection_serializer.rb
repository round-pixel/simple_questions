class AnswerCollectionSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :question_id
end
