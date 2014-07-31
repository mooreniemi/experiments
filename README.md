experiments
===========

- **curried_summer.rb** explores partial function application in Ruby, specifically for inject patterns. Inject has argument order conducive to partial application, whereas the new each_with_object has the opposite order. This is the same issue scoreunder corrects in JS's underscore. 
- **monad_enumerable.rb** implements bind, unit (join), and filterM.

To run the test yourself, clone this repo, cd into it, `bundle install`, then use `rspec curried_summer.rb`.
