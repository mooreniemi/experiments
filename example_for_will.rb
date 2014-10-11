# This example is a refactoring of an example exercise code in getting different outputs
# for different inputs to the console in Ruby. The point of the refactoring is to use some
# object orientation and functional principles to tidy it up and make it more readable.

# For instructions on how to run this code, see bottom of file.

# ruby class is instantiated with .new method, ie, Foodler.new
class Foodler
  # accessors allow you to call @pizza and @burger within your class without the @
  attr_accessor :pizza, :burger

  # this is what .new calls, setting these two properties when you initialize your object
  def initialize
    @pizza = 'Pizza sounds good.'
    @burger = 'Burger sounds good.'
  end

  # this is an instance method, so you do foo = Foodler.new; foo.start to call
  # more conceptually, it is a "driver" method, it is a method used to call several other methods, driving them
  def start
    food = ask_for_food # method that prints question and captures response

    # use helper methods to check if response
    if good(food) 
      # then tell them good job using the message initialized at top
      approve_of(food)
    else
      # if it isn't a good food, then recursively restart this function
      start
    end
  end

  # method that takes a string of a food name (or whatever other word your user put in!)
  # and returns either true or false
  def good(food)
    is_pizza?(food) || is_burger?(food)
  end

  # helper methods for good method
  def is_pizza?(food)
    food == 'Pizza'
  end

  def is_burger?(food)
    food == 'Burger'
  end

  # uses the instance variables via the attr_accessor you initialized in this instance
  def approve_of(food)
    is_pizza?(food) ? puts("#{pizza}") : puts("#{burger}")
  end

  # prints question to screen
  def ask_for_food
    puts 'What food should I get? Pizza or burger?'
    gets.chomp.capitalize
  end
end

# to use in the console, save this as a file
# use irb in that file directory, and in irb do require './your_file_name'
# then do foo = Foodler.new
# then foo.start :)