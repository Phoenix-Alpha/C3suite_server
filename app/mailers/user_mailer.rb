class UserMailer < ApplicationMailer

  def sample_email(user,flag,product)
    @product = product
    @flag = flag
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end

  def instructions_for_password_reset(user)
    @user = user
    mail(to: @user.email, subject: 'Reset password instructions') if user.present? and (generate_reset_token user)
  end

  private
  def generate_reset_token user
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    @token = raw
    user.reset_password_token = hashed
    user.reset_password_sent_at = Time.now.utc
    user.save
  end
end
