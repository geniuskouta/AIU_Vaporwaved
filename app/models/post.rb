class Post < ActiveRecord::Base
  include SearchPost
  #This validates presence of title, and makes sure that the length is not more than 140 words
  validates :title, presence: true, length: {maximum: 140}
  #This validates presence of body
  validates :body, presence: true
    has_many :categorizations
    has_many :categories, :through => :categorizations 
    paginates_per 3
end