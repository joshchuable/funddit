class School < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :user
  has_many :project
  belongs_to :state
  def self.array
    return @array if @array
    @array = ["Truman State University", "Missouri State University", "Missouri S&T", "Kansas State", "Kansas University", "Washington University", "William Jewel", "St. Louis University", "Denison University"]
    #self.order(:name).each do |school|
    #  @array << [school.name]
    #end
    @array.push(['Other'])
    @array
  end
end
