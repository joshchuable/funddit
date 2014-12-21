class School < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :user
  has_many :project
  belongs_to :state
  def self.array
    return @array if @array
    @array = ["Arizona State",
              "Baylor",
              "Denison University",
              "Kansas State",
              "Missouri State",
              "Missouri S&T",
              "Notre Dame",
              "Pittsburg State University",
              "St. Louis University",
              "Truman State University",
              "UMKC",
              "UMSTL",
              "University of Central Missouri",
              "University of Kansas",
              "University of Nebraska Lincoln"
              "University of Michigan",
              "University of Missouri",
              "Washington University St. Louis",
              "William Jewell College"
              ]
    #self.order(:name).each do |school|
    #  @array << [school.name]
    #end
    @array.push(['Other'])
    @array
  end
end
