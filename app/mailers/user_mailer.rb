class UserMailer < ApplicationMailer
  def user_changed
    user_to_archive = params[:user_to_archive]
    @user = params[:user]
    @action = params[:action]
    mail(to: user_to_archive.email, subject: "user changed")
  end
end
