class School < ActiveRecord::Base
  validates_presence_of :name, :acronym
  validates_uniqueness_of :name, :acronym
  has_many :user
  has_many :project
  belongs_to :country
  belongs_to :state
  def self.array
    return @array if @array
    @array = []
    self.order(:name).each do |state|
      @array << [state.name, state.acronym]
    end
    @array.push(['Other / Other', 'other / other'])
    @array
  end
end
