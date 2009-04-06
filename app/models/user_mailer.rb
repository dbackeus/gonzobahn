class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    
    @subject    += t("user_mailer.signup_notification.subject")
    @body[:url]  = "http://#{SITE_HOST}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    
    @subject    += t("user_mailer.activation.subject")
    @body[:url]  = "http://#{SITE_HOST}/"
  end
  
  protected
  def setup_email(user)
    recipients user.email
    from "noreply@diktafonen.com"
    subject "[#{t("sitename")}] "
    @body[:user] = user
  end
end
