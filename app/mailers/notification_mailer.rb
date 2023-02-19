class NotificationMailer < ActionMailer::Base
  default from: "together@wearebrightly.com"

  def join(user, download, code)
    @code = code
    @download = download.code
    mail(:to => user.email, :subject => "Thanks for joining!")
  end

  def album(user, download, code)
    @code = code
    @download = download.code
    mail(:to => user.email, :subject => "Download your copy of Beginnings & Endings!")
  end

  def get_more_codes(type)
    @type = type
    mail(:to => 'together@wearebrightly.com', :subject => "Codes are running low Charlie!")
  end
end
