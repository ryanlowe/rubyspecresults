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
  
  attr_accessible :log, :files_count, :examples_count, :expectations_count, :failures_count, :errors_count
  
  def before_validation
    unless self[:log].nil?
      self[:log].strip!
      self[:files_count]        = 0 if self[:files_count].nil?
      self[:examples_count]     = 0 if self[:examples_count].nil?
      self[:expectations_count] = 0 if self[:expectations_count].nil?
      self[:failures_count]     = 0 if self[:failures_count].nil?
      self[:errors_count]       = 0 if self[:errors_count].nil?
    end
  end
  
  def created_by?(user)
    return false if user.nil?
    (user.id == self.created_by)
  end
  
  def to_s
    "Result #{self.id.to_s}"
  end

end
