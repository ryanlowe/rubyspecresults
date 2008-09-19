class Target < ActiveRecord::Base  
  acts_as_indestructible
  
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  validates_existence_of :creator
  
  has_many :results
  
  validates_presence_of   :secret
  validates_presence_of   :impl
  validates_presence_of   :impl_branch
  validates_presence_of   :spec_version
  validates_presence_of   :arch
  validates_presence_of   :os
  
  attr_accessible :impl, :impl_branch, :spec_version, :arch, :os, :continuous, :notes
  
  def before_validation
    self[:secret] = generate_secret(6) if self.new_record?
    self[:impl].strip!         unless self[:impl].nil?
    self[:impl_branch].strip!  unless self[:impl_branch].nil?
    self[:spec_version].strip! unless self[:spec_version].nil?
    self[:arch].strip!         unless self[:arch].nil?
    self[:os].strip!           unless self[:os].nil?
    self[:notes].strip!        unless self[:notes].nil?
  end
  
  def secret=(s) #override ActiveRecord
    raise "Not implemented"
  end
  
  def created_by?(user)
    return false if user.nil?
    (user.id == self.created_by)
  end
  
  def to_s
    "Target #{self.id.to_s}"
  end
  
  protected
  
    def generate_secret(length)
      chars = ("0".."9").to_a.concat(("a".."z").to_a)
      while true
        new_secret = ""
        1.upto(length) { |i| 
          new_secret << chars[rand(chars.size-1)]
        }
        return new_secret if Target.find_by_secret(new_secret).nil?
      end
    end
  
end
