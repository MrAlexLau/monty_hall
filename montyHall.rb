# This program simulates the monty hall problem
# It has 3 command line arguments:
#  1. The number of simulations to run (default 100)
#  2. A boolean for outputting the details of EACH game (defaults to false)
#  3. A boolean for interactive mode. if set to true, user input is required. if it's false, simulations are run automatically with random door choices (defaults to false)
#  4. The number of total doors for each simulation (default 3 doors).

# Example:
#   $ ruby montyHall.rb 500 true false 5
# The line above runs the program with 500 simulations, using 5 doors and showing the details for each game, and automatically choosing random doors for each simulation.

$LOAD_PATH << '.'
require 'options.rb'
require 'simulation.rb'

options = get_options(ARGV[0] || 100, ARGV[1] == 'true', ARGV[2] == 'true', ARGV[3] || 3)

# clear out arguments so "gets" method can be used later
ARGV.clear

simulation_manager = SimulationManager.new(options)
simulation_manager.run_simulations
simulation_manager.print_stats

