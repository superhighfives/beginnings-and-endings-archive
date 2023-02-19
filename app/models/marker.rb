class Marker < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper

  attr_accessible :email, :latitude, :longitude, :location, :referrer_code, :is_subscriber
  attr_accessor :relative_time, :participants,  :participant_count, :code

  validates :email, :presence => true, :uniqueness => {:message => "is already taken"}, :email_format => {:message => "doesn't appear to be valid"}
  validates :location, :presence => true
  validates :latitude, :presence => true
  validates :longitude, :presence => true

  validates :referrer_code, :inclusion => {:in => proc { Marker.all.map { |marker| marker.code } }, :message => "%{value} doesn't appear to be a valid code?"}, :allow_blank => true

  after_create :increment_referrer, :send_join_email

  def increment_referrer
    if self.referrer_code?
      @referrer = Marker.find_by_code(self.referrer_code)
      if @referrer
        @referrer.increment_num_referred
        @referrer.save
        if @referrer.referrer_code?
          Marker.recursive_increment @referrer.referrer_code
        end
      end
    end
  end

  def self.recursive_increment referrer_code
    marker = Marker.find_by_code(referrer_code)
    if marker
      marker.increment_num_referred
      marker.save
      if marker.referrer_code?
        Marker.recursive_increment marker.referrer_code
      end
    end
  end

  def increment_num_referred
    self.num_referred = self.num_referred + 1
    if self.num_referred == 10
      self.send_album_email
    end
  end

  def relative_time
    time_ago_in_words(self.created_at).capitalize
  end

  def participants
    pluralize(self.num_referred, "participant")
  end

  def participant_count
    self.num_referred + 1
  end

  def self.check_code_exists(code)
    return self.all.map { |marker| marker.code }.include?(code)
  end

  def self.find_by_code(code)
    maximum_value_for_postgres_integer = 2147483647
    id = code.base62_decode - 10000
    if id > maximum_value_for_postgres_integer
      raise ActiveRecord::RecordNotFound.new("base62 encoded id #{code}=#{id} which is out of range for Copy#id")
    end
    find(id)
  end

  def code
    (id + 10000).base62_encode
  end

  def send_join_email
    code = self.code
    download = Download.get(:single)
    mail = NotificationMailer.join(self, download, code).deliver
  end

  def send_album_email
    code = self.code
    download = Download.get(:album)
    if(download)
      self.has_album = true
      self.save
      mail = NotificationMailer.album(self, download, code).deliver
    else
      mail = NotificationMailer.get_more_codes('failed album send').deliver
    end
  end

end
