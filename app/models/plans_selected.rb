class PlansSelected < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  enum :duration, monthly: 30, quarterly: 90, semiannual: 180, annual: 360 

  validates :user, uniqueness: { message: "User can have only one plan selected." }

  scope :find_by_user, ->(user) { where(user_id: user.id) }
  scope :active, -> { where("day_used < duration") }

  def self.find_plan_selected_by_user(user) 
    PlansSelected.joins(:plan)
                 .joins(:user)
                 .where("plans_selecteds.day_used < plans_selecteds.duration and plans_selecteds.user_id = #{user.id}").take
  end

  # Atualiza os dias usados para todos os planos ativos
  def self.update_used_days
    active.each do |plan|
      plan.with_lock do
        plan.increment!(:day_used, 15)
      end
    end
  end

  # Verifica planos próximos do vencimento e envia notificações
  def self.check_expiring_plans
    active.each do |plan|
      days_remaining = plan.duration - plan.day_used
      
      if days_remaining == 15
        PlanExpirationMailer.expiration_notice(plan).deliver_later
      end
    end
  end

  # Verifica se o plano está próximo do vencimento (15 dias)
  def near_expiration?
    (duration - day_used) == 15
  end
end
