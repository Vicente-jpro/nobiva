class PlanExpirationMailer < ApplicationMailer
  def expiration_notice(plans_selected)
    @plans_selected = plans_selected
    @user = plans_selected.user
    @plan = plans_selected.plan
    @days_remaining = plans_selected.duration - plans_selected.day_used

    mail(
      to: @user.email,
      subject: "Seu plano expirará em 15 dias"
    )
  end
end
