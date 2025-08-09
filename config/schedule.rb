# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# Configura o ambiente
env :PATH, ENV['PATH']
set :environment, 'development'
set :output, "log/cron.log"

# Atualiza os dias usados a cada 15 dias
every 15.days do
  runner "PlansSelected.update_used_days"
end

# Verifica planos expirando todos os dias às 8 da manhã
every 1.day, at: '8:00 am' do
  runner "PlansSelected.check_expiring_plans"
end
