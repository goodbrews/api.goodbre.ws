require Grape.root.join('app/models/brewery')
require Grape.root.join('app/models/style')

class Beer < ActiveRecord::Base
  has_and_belongs_to_many :breweries
  belongs_to :style

  before_destroy { breweries.clear }

  def to_param
    brewerydb_id
  end
end
