class MailJob < ApplicationJob
  queue_as :mailers

  def perform(method, user_id, token)
    user = User.find(user_id)

    Mailer.public_send(method, user, token)
  end
end