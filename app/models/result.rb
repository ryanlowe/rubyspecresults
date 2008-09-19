class Result < ActiveRecord::Base
  acts_as_indestructible
  
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  validates_existence_of :creator
  
  belongs_to :target
  validates_existence_of :target
  
  validates_presence_of   :log
  validates_presence_of   :files_count
  validates_presence_of   :examples_count
  validates_presence_of   :expectations_count
  validates_presence_of   :failures_count
  validates_presence_of   :errors_count
  
  def before_validation
    self[:log].strip! unless self[:log].nil?
  end

end
