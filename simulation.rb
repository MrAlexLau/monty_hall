class Simulation
  def initialize(options)
    @options = options
    @num_doors = @options[:number_of_doors]
    @interactive_mode = @options[:interactive_mode]
    @show_details = @options[:show_details]
  end

  def set_up_doors
    all_doors = []
    for door_number in (1..@num_doors) do
      # use a 1 based index for the door number
      # so that when displaying output it shows 1-3 instead of 0-2
      all_doors << { value: :goat, state: :closed, number: door_number }
    end

    # put a car as the prize for one of the doors
    all_doors[rand(0..@num_doors - 1)][:value] = :car
    @door_with_prize = all_doors.select { |hash| hash[:value] == :car }.first[:number]

    all_doors
  end

  def contestant_wants_to_switch?
    if @interactive_mode
      puts "Do you want to switch doors? (yN)"
      contestant_wants_to_switch = gets.chomp == 'y'
    else
      contestant_wants_to_switch = [true, false].sample
      if contestant_wants_to_switch
        puts "Contestant chooses to switch guess" if @show_details
      else
        puts "Contestant chooses NOT to switch guess" if @show_details
      end
    end

    contestant_wants_to_switch
  end

  def get_switched_door(first_guess, revealed_door)
    # an array of door numbers that can be guessed
    # note that the contestants first guess nor revealed door can be guessed
    guessable_doors = (1..@num_doors).to_a - [revealed_door, first_guess]
    if @interactive_mode
      if guessable_doors.length == 1 # when there are 3 doors, there's only one choice for the switched guess
        final_guess = guessable_doors.first
      else
        while guessable_doors.select { |el| el == final_door_guess }.empty? # keep looping until the user picks a guessable door
          puts "Door number to switch to:"
          final_door_guess = gets.to_i
        end
      end
    else
      # randomly pick the second door on the contestant's behalf
      guessable_doors.sample
    end
  end

  def contestants_second_guess(first_guess, revealed_door)
    if contestant_wants_to_switch?
      final_guess = get_switched_door(first_guess, revealed_door)
    else
      # contestant does NOT want to switch
      final_guess = first_guess
    end

    final_guess
  end

  def contestants_first_guess
    if @interactive_mode
      # get input from contestant
      puts "Enter a door number:"
      contestants_guess = gets.to_i
    else
      contestants_guess = rand(1..@num_doors)
      puts "Contestant's initial guess: #{contestants_guess}" if @show_details
    end

    contestants_guess
  end

  def reveal_door(contestants_initial_guess, door_with_prize)
    # an array of door numbers that can be revealed
    # note that the contestants guess nor the door with the car can be revealed
    revealable_doors = (1..@num_doors).to_a - [door_with_prize, contestants_initial_guess]
    revealed_door_number = revealable_doors.sample

    @all_doors[revealed_door_number - 1][:state] = :opened
    puts "Door #{revealed_door_number} opens" if @show_details

    revealed_door_number
  end

  def display_game_results(final_guess, door_with_prize, prize_found, switching_wouldve_helped)
    if @show_details
      puts "Final guess: #{final_guess}"
      puts "Door with car: #{door_with_prize}"
      puts "Contestant's final guess was correct: #{prize_found}"
      puts "Switching would have helped: #{switching_wouldve_helped}"
    end
  end

  def run
    @all_doors = set_up_doors

    contestants_initial_guess = contestants_first_guess
    revealed_door_number = reveal_door(contestants_initial_guess, @door_with_prize)
    final_guess = contestants_second_guess(contestants_initial_guess, revealed_door_number)

    prize_found = @all_doors[final_guess - 1][:value] == :car
    contestant_switched = (contestants_initial_guess != final_guess)
    switching_wouldve_helped = (@door_with_prize != contestants_initial_guess)

    display_game_results(final_guess, @door_with_prize, prize_found, switching_wouldve_helped)
    set_result(prize_found, contestant_switched)
  end

  def set_result(prize_found, contestant_switched)
    if prize_found
      # contestant won
      if contestant_switched
        @result = :switched_and_won
      else
        @result = :didnt_switch_and_won
      end
    else
      # contestant lost
      if contestant_switched
        @result = :switched_and_lost
      else
        @result = :didnt_switch_and_lost
      end
    end
  end

  def get_result
    @result
  end
end

