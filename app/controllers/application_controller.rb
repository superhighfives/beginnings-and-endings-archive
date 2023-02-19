class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_browser

  def current_browser
    @browser = Browser.new(:ua => request.user_agent)
    if (@browser.ie6? || @browser.ie7? || @browser.ie8? || @browser.ie9?) && request.env['PATH_INFO'] != "/ie"
      redirect_to '/ie'
    end
  end
end
