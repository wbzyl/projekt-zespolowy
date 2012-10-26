class Project

  include Mongoid::Document
  field :name, type: String
  field :description, type: String

  attr_accessible :name, :description

  validates :name, :presence => true

end
