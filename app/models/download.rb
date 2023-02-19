class Download < ActiveRecord::Base
  belongs_to :marker

  attr_accessible :code, :reference, :used, :created_at, :updated_at

  validates :code, :presence => true, :uniqueness => true

  def self.get(type)
    if Download.where(:used => false, :reference => type).count <= 50
      mail = NotificationMailer.get_more_codes(type).deliver
    end
    @download = Download.where("used = ? AND reference = ?", false, type).first
    if @download
      @download.used = true
      @download.save
    end
    return @download
  end

  def self.has_no_singles
    Download.where(:used => false, :reference => :single).count == 0
  end
end
