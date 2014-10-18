# This program simulates the monty hall problem
# It has 4 command line arguments:
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
require 'simulation_manager.rb'

# read command line args
number_of_simulations = (ARGV[0] || 100).to_i
show_details = ARGV[1] == 'true'
interactive_mode = ARGV[2] == 'true'
number_of_doors = ARGV[3] || 3 # default to 3 doors

options = get_options(number_of_simulations, show_details, interactive_mode, number_of_doors)

# clear out arguments so "gets" method can be used later
ARGV.clear

simulation_manager = SimulationManager.new(options)
simulation_manager.run_simulations
simulation_manager.print_stats
