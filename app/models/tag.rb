class Tag < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true,
                   :length => { :within => 1..30 },
                   :uniqueness => true

  belongs_to :user
  has_many :snippets, :through => :tagged_snippets
end
