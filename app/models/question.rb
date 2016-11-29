class Question < ApplicationRecord
  has_many :answers,     dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, presence: true
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
