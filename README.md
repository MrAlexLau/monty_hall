# Monty Hall Simulator [![Code Climate](https://codeclimate.com/github/MrAlexLau/monty_hall/badges/gpa.svg)](https://codeclimate.com/github/MrAlexLau/monty_hall)

This program simulates the [monty hall problem](http://en.wikipedia.org/wiki/Monty_Hall_problem). It accepts 4 command line arguments:
 1. The number of simulations to run (default 100)
 2. A boolean for outputting the details of EACH game (defaults to false)
 3. A boolean for interactive mode. if set to true, user input is required. if it's false, simulations are run automatically with random door choices (defaults to false)
 4. The number of total doors for each simulation (default 3 doors).

Example:
``` bash
  $ ruby monty_hall.rb 500 true false 5
```
The line above runs the program with 500 simulations, using 5 doors and showing the details for each game, and automatically choosing random doors for each simulation.
