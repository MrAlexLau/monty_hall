def SimulationManager
  def initialize(options)
    @options = options
    #total_wins_when_switching = 0
    #total_losses_when_switching = 0
    #total_wins_when_keeping_guess = 0
    #total_losses_when_keeping_guess = 0
    #use_random_guesses = !use_interactive_mode
  end

  def run_simulations
    @options[:number_of_simulations].times do
      simulation = Simulation.new(@options)
      simulation.run
      log_result(simulation.result)
    end
  end

  def log_result(result)
    @result_totals = {
      switched_and_won: 0,
      switched_and_lost: 0,
      didnt_switch_and_won: 0,
      didnt_switch_and_lost: 0
    }

    @result_totals[result] += 1
  end

  def win_percentage_when_switching(result_totals)
    percentage = result_totals[:switched_and_won].to_f / (result_totals[:switched_and_won] + result_totals[:switched_and_lost]) * 100
    percentage = 0 if percentage.nan?
    percentage = percentage.round(2)
  end

  def win_percentage_when_keeping_guess(result_totals)
    percentage = result_totals[:didnt_switch_and_won].to_f / (result_totals[:didnt_switch_and_won] + result_totals[:didnt_switch_and_lost]) * 100
    percentage = 0 if percentage.nan?
    percentage = percentage.round(2)
  end

  def print_stats
    puts "---------------------------------------------------"
    # details for when the contestant switches
    puts "Number of wins when switching: #{@result_totals[:switched_and_won]}"
    puts "Number of losses when switching: #{@result_totals[:switched_and_lost]}"
    puts "Win % when switching: #{win_percentage_when_switching(@result_totals)}%"

    puts "---------------------------------------------------"
    # details for when the contestant doesn't switch
    puts "Number of wins when keeping the same guess: #{@result_totals[:didnt_switch_and_won]}"
    puts "Number of losses when keeping the same guess: #{@result_totals[:didnt_switch_and_lost]}"
    puts "Win % when keeping guess: #{win_percentage_when_keeping_guess[@result_totals]}%"
  end
end
