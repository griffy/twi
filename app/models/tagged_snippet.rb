class TaggedSnippet < ActiveRecord::Base
  belongs_to :snippet
  belongs_to :tag
end
