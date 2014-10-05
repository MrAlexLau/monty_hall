class SimulationManager
  def initialize(options)
    @options = options

    @result_totals = {
      switched_and_won: 0,
      switched_and_lost: 0,
      didnt_switch_and_won: 0,
      didnt_switch_and_lost: 0
    }
  end

  def run_simulations
    for i in (1..@options[:number_of_simulations])
      puts "Game #{i}: " if @options[:show_details]
      simulation = Simulation.new(@options)
      simulation.run
      log_result(simulation.get_result)
      puts "\n\n" if @options[:show_details]
    end
  end

  def log_result(result)
    @result_totals[result] += 1
  end

  def win_percentage(total_won, total_lost)
    percentage = total_won == 0 ? 0 : total_won.to_f / (total_won + total_lost) * 100
    percentage = percentage.round(2)
  end

  def print_stats
    puts "---------------------------------------------------"
    # details for when the contestant switches
    puts "Number of wins when switching: #{@result_totals[:switched_and_won]}"
    puts "Number of losses when switching: #{@result_totals[:switched_and_lost]}"
    puts "Win % when switching: #{win_percentage(@result_totals[:switched_and_won], @result_totals[:switched_and_lost])}%"

    puts "---------------------------------------------------"
    # details for when the contestant doesn't switch
    puts "Number of wins when keeping the same guess: #{@result_totals[:didnt_switch_and_won]}"
    puts "Number of losses when keeping the same guess: #{@result_totals[:didnt_switch_and_lost]}"
    puts "Win % when keeping guess: #{win_percentage(@result_totals[:didnt_switch_and_won], @result_totals[:didnt_switch_and_lost])}%"
  end
end

