class Snippet < ActiveRecord::Base
  attr_accessible :title, :content, :visibility
  
  validates :title, :presence => true,
                    :length => { :within => 1..30 },
                    :uniqueness => true # is this the case?
  validates :content, :presence => true,
                      :length => { :within => 1..1000 }
  validates :visibility, :presence => true,
                         :numericality => { :only_integer => true }

  belongs_to :user
end
