def Simulation
  def initialize(options)
    @options = options
  end

  # returns 1 based index for which door to reveal
  # based on what the contestant guesses and which door the car is behind
  def get_opened_door_number(contestants_guess, number_of_door_with_car, total_number_of_doors)
    possible_open_doors = []
    for i in 1..total_number_of_doors 
      if i != contestants_guess and i != number_of_door_with_car
        possible_open_doors << i
      end
    end
    
    return possible_open_doors[rand(0..possible_open_doors.length - 1)]
  end

  def set_up_doors(num_doors)
    @all_doors = Array.new(num_doors).tap do |door|
      door = 'goat'
    end

    # put a car as the prize for one of the doors
    @all_doors[rand(0..num_doors)] = 'car'
  end

  def get_contestants_guess(interactive_mode)
    contestants_initial_guess = 0
    if use_randomized_guessing
      contestants_initial_guess = rand(1..number_of_doors)
      puts "Contestant's initial guess: #{contestants_initial_guess}" if show_details
    else 
      #get input from contestant
      puts "Enter a door number:"
      contestants_initial_guess = gets.to_i
    end
  end

  def run
    set_up_doors(@options[:number_of_doors])
    contestants_guess = get_contestants_guess(@options[:interactive_mode]) #TODO: resume here

    opened_door = get_opened_door_number(contestants_initial_guess, door_with_car, number_of_doors)

    puts "Door #{opened_door} opens" if show_details
    if use_randomized_guessing
      if rand(1..2) == 1
        contestant_wants_to_switch = 'y'
        puts "Contestant chooses to switch guess" if show_details
      else
        puts "Contestant chooses NOT to switch guess" if show_details
      end
    else
      puts "Do you want to switch doors?" 
      contestant_wants_to_switch = gets.chomp
    end

    final_door_guess = 0
    if contestant_wants_to_switch == 'y'
      if use_randomized_guessing
        #pick a random door for the 2nd guess
        possible_final_guesses = Array.new

        for i in 1..number_of_doors
          if i != contestants_initial_guess and i != opened_door
            possible_final_guesses << i 
          end
        end

        final_door_guess = possible_final_guesses[rand(0..possible_final_guesses.length - 1)]
      else
        #have the contestant pick another door
        if number_of_doors > 3 
          while final_door_guess != contestants_initial_guess and final_door_guess != opened_door
            puts "Door number to switch to:"
            final_door_guess = gets.to_i
          end
        else
          #for 3 doors, there is no decision to be made on which door is the "new" door
          for i in 1..number_of_doors
            if i != contestants_initial_guess and i != opened_door
              final_door_guess = i
            end
          end
          
        end
      end
    else #contestant does NOT want to switch
      final_door_guess = contestants_initial_guess
    end

    contestant_guessed_correctly = false
    if final_door_guess == door_with_car
      contestant_guessed_correctly = true 
    end

    switching_wouldve_helped = false
    if door_with_car != contestants_initial_guess
      switching_wouldve_helped = true
    end

    if show_details
      puts "final guess: #{final_door_guess}"
      puts "door with car: #{door_with_car}"
      puts "contestant guessed correctly: #{contestant_guessed_correctly}"
      puts "switching would have helped: #{switching_wouldve_helped}"
    end

    results = Hash.new
    results[:contestant_switched] = (contestant_wants_to_switch == 'y')
    results[:contestant_guessed_correctly] = contestant_guessed_correctly 
    
    return results
  end

  total_wins_when_switching = 0
  total_losses_when_switching = 0
  total_wins_when_keeping_guess = 0
  total_losses_when_keeping_guess = 0


  use_random_guesses = !use_interactive_mode

  for i in 1..options[:number_of_simulations]
    results = run_game(default_number_of_doors, use_random_guesses, show_details_option)
    if results[:contestant_switched]
      if results[:contestant_guessed_correctly]
        total_wins_when_switching += 1 
      else
        total_losses_when_switching += 1 
      end
    else
      if results[:contestant_guessed_correctly]
        total_wins_when_keeping_guess += 1 
      else
        total_losses_when_keeping_guess += 1 
      end
    end
  end

  puts ""
  #details for when the contestant switches
  puts "wins when switching: #{total_wins_when_switching}" if show_details_option 
  puts "losses when switching: #{total_losses_when_switching}" if show_details_option 

  win_percentage_when_switching = total_wins_when_switching.to_f / ( total_wins_when_switching + total_losses_when_switching ) * 100
  win_percentage_when_switching = 0 if win_percentage_when_switching.nan?
  win_percentage_when_switching = win_percentage_when_switching.round(2)
  puts "win % when switching: #{win_percentage_when_switching}%"

  puts ""
  #details for when the contestant switches
  puts "wins when keeping the same guess: #{total_wins_when_keeping_guess}" if show_details_option 
  puts "losses when keeping the same guess: #{total_losses_when_keeping_guess}" if show_details_option 

  win_percentage_when_keeping_guess = total_wins_when_keeping_guess.to_f / (total_wins_when_keeping_guess + total_losses_when_keeping_guess) * 100
  win_percentage_when_keeping_guess = 0 if win_percentage_when_keeping_guess.nan?
  win_percentage_when_keeping_guess = win_percentage_when_keeping_guess.round(2)
  puts "win % when keeping guess: #{win_percentage_when_keeping_guess}%"

end

