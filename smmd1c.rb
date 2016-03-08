class Mastermind # Class Mastermind, this is Super Mastermind smmd1c.rb
  require './colorize_terminal.rb' # Additional file to create our "colored blocks"
  # colors = "R" Red,"Y" Yellow,"G" Green,"C" Cyan,"B" Blue,"P" Pink (for guessing)
  # others =  "W" White, "K" Black (need two additional colors to make Super MM harder)
  # Also, "W" White, "K" Black (for scoring)
  # * redb(string)      "\e[41m#{string}\e[0m"
  # * yellowb(string)   "\e[43m#{string}\e[0m"
  # * greenb(string)    "\e[42m#{string}\e[0m"
  # * cyanb(string)     "\e[46m#{string}\e[0m"
  # * blueb(string)     "\e[44m#{string}\e[0m"
  # * pinkb(string)     "\e[45m#{string}\e[0m"
  # * whiteb(string)    "\e[47m#{string}\e[0m"
  # * blackb(string)    "\e[40m#{string}\e[0m"
  # greyify(string)   "\e[37m#{string}\e[0m"
  # greenify(string)  "\e[32m#{string}\e[0m"
  # redify(string)    "\e[31m#{string}\e[0m"
  # goldify(string)   "\e[33m#{string}\e[0m"
  # purplify(string)  "\e[34m#{string}\e[0m"
  # pinkify(string)   "\e[35m#{string}\e[0m"
  # skybluify(string) "\e[36m#{string}\e[0m"
  # blackify(string)  "\e[30m#{string}\e[0m"
  # whatify(string)   "\e[28m#{string}\e[0m"
  # boldg(string)     "\e[1;32m#{string}\e[0m"

#------------------------------------------------------------------------------------------

  def initialize # Method initialize, allocate space for objects
    arr = [] # Array arr set up with 0 elements
    colors = ["R","Y","G","C","B","P","K","W"] # Array colors holds all 8 available peg colors
    computer = [] # Array computer set up with 0 elements
    5.times { arr << rand(8) } # Loop to insert 5 random numbers from 0 to 7, as characters in a string
    arr.each { |x| computer << colors[x] } # For each # in the array, replace with corresponding coded color
    # for example, if the randomly picked array "arr" is 12345, array computer gets "R","Y","G","C","B"
    # $variables are global, @variables are instance variables
    @master = computer # assign instance variable @master (Secret Code!) with the contents of array computer
    @color_blocks = {"R" => "#{redb(" ")}", "Y" => "#{yellowb(" ")}", "G" => "#{greenb(" ")}", "C" => "#{cyanb(" ")}", "B" => "#{blueb(" ")}", "P" => "#{pinkb(" ")}", "K" => "#{blackb(" ")}", "W" => "#{whiteb(" ")}"}
    # assign instance variable @color_blocks to the complete color set RYGCBPKW, but colored blocks of each 
    @guesses = [] # initialize instance array @guesses to empty
    @guesses_in_color = [] # initialize instance array @guesses_in_color to empty
  end

#------------------------------------------------------------------------------------------

  def instructions # Method, Print Instructions to the screen
    # cls = clear screen with # 35 lines
    35.times { puts "\n " } # 35 times do this - put a new line and a space on the screen
    puts "     LET'S PLAY #{boldg("SUPER MASTERMIND")}!! Guess the 5 colored pegs in 12 turns!"
    puts "     Skye-Free's Ruby version of Mastermind, fixed up a little bit -RC97"
    puts "        Note - Enter only 5 pegs, of the 8 colors from options below"
    puts "\n                             *Options*"
    puts "                          #{@color_blocks.keys.join(" ")}"
    puts "                          #{@color_blocks.values.join(" ")}"
    puts "                             *Feedback*"
    puts "                      #{whiteb(" ")} Right Color, Wrong Spot"
    puts "                      #{blackb(" ")} Right Color, Right Spot\n"
    puts "                Please enter your guess, e.g. 'rygck' "
  end

#------------------------------------------------------------------------------------------

  def make_guess # get input guess, separate characters, make upper case
    gets.chomp.upcase.split(//)
  end
 
#------------------------------------------------------------------------------------------

  def array_to_list(array) # Change ("Y", "G", "C", "B", "P") to ('Y' 'G' 'C' 'B' 'P')
    readx = array.map{ |i|  %Q('#{i}') }.join(' ')
  end

#------------------------------------------------------------------------------------------

  def array_to_color_blocks(array) # Change "Y","G","C","B","P" to corresponding color blocks
    ready = array.map { |e| @color_blocks[e] }
    ready.join(" ") # separate color blocks with spaces for better appearance
  end

#------------------------------------------------------------------------------------------

  # Changed to display current round, instead of all together without B or W scores.
  def display_rounds(i) # And still wishing it was all on a single line...
    # print "#{@guesses[i]} " #               Output is ["C", "Y", "C", "Y", "C"]
    print " #{array_to_list(@guesses[i])} " # Output is 'C' 'Y' 'C' 'Y' 'C'
    (i+1).upto(i+1) do |n|
      display_guess(i)
    end
  end

#------------------------------------------------------------------------------------------

  def display_guess(i)
    print i < 9 ? " Round 0#{i+1}: #{@guesses_in_color[i]}" : " Round #{i+1}: #{@guesses_in_color[i]}" 
  end

#------------------------------------------------------------------------------------------

  def black_pegs(master, guess)
    for i in (0..4) do
      if guess[i] == master[i]
        master[i] = 'X'
        guess[i] = 'V'
      end
    end
    master
  end

#------------------------------------------------------------------------------------------

  def white_pegs(master, guess)
    for i in (0..4) do
      if master.include?(guess[i])
        master[master.index(guess[i])] = 'O'
        guess[i] = 'Z'
      end
    end
    master
  end

#------------------------------------------------------------------------------------------

  def get_feedback(m, g)
    mas = m.dup
    gue = g.dup
    feedback = []
    white_pegs(black_pegs(mas, gue), gue)
  end

#------------------------------------------------------------------------------------------

  def print_feedback(array)
    feedback = []
    array.each do |e|
      if e == 'X'
        feedback << "#{blackb(" ")}"
      elsif e == 'O'
        feedback << "#{whiteb(" ")}"
      else
        next
      end
    end 
    feedback
  end

#------------------------------------------------------------------------------------------

  def game_over?(i)
    if @guesses[i] == @master
      true
    elsif i == 11
      true
    else
      false
    end
  end

#------------------------------------------------------------------------------------------

  def finished
    if @guesses.last == @master
      puts "\n\nCongratulations, #{boldg("YOU WON")}!\n"
    else
      puts "\n\nYou lost! Correct code was: #{array_to_color_blocks(@master)}"
      puts "                        #{array_to_list(@master)} " # Output is 'C' 'Y' 'C' 'Y' 'C'
    end
  end

#------------------------------------------------------------------------------------------

  def round(i) # User makes a guess
    # print "\nPlease take a guess, e.g. 'rygc' >> "
    print "\n>>"
    @guesses[i] = make_guess
    # Convert to colors
    @guesses_in_color[i] = array_to_color_blocks(@guesses[i])
    # was "Display all rounds of guesses" now only the current round!
    display_rounds(i)
    # Give user feedback
    user_feedback = get_feedback(@master, @guesses[i])
    # print "\nFeedback:  " + print_feedback(user_feedback).sort.join(" ") # I don't want the 'new line'
    print "  Feedback: " + print_feedback(user_feedback).sort.join(" ") # just a space please
    # testing outputs
    # print "\n testing outputs "
    # puts " Your Guess was:  #{array_to_list(@guesses[i])}"
    # puts " Your Guess was:  #{array_to_color_blocks(@guesses[i])}"
    # puts " Correct code is: #{array_to_color_blocks(@master)}"
  end

#------------------------------------------------------------------------------------------

  def rounds
    12.times do |i|
      round(i)
      break if game_over?(i)
    end
  end
end

#------------------------------------------------------------------------------------------

game = Mastermind.new
game.instructions
game.rounds
game.finished

#------------------------------------------------------------------------------------------

# Wishes - an easy way to place output in a specific spot on the screen? (Try another programming language?)
# If I bothered to flowchart this and dig deeper, it could be a little more simple?
# Supposedly, there was some control character sequence to get a Backspace?
# which would have maybe enabled me to erase the input line (>>bpbrc) and clear more screen or overwite it?
