module ApplicationHelper

  def has_flash
    !flash[:notice].nil? || !flash[:alert].nil?
  end

end
