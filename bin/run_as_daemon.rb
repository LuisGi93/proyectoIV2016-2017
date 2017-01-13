require_relative 'queveo'
require 'daemons'


options = {
  :app_name   => "queveobot",
}



Daemons.call(options) do
  # Server loop:
	bot =Bot.new(ENV['TOKEN'])
	bot.empezar()

end


