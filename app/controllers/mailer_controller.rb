class MailerController < ApplicationController

  def teaser()
    render :file => 'notification_mailer/teaser.html.haml', :layout => 'notification_mailer'
  end

  def join()
    @code = 'xyz123'
    @download = 'fhie-59fj'
    render :file => 'notification_mailer/join.html.haml', :layout => 'notification_mailer'
  end

  def album()
    @code = 'abc789'
    @download = 'dhid-22ks'
    render :file => 'notification_mailer/album.html.haml', :layout => 'notification_mailer'
  end

end
