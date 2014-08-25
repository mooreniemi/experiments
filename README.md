experiments
===========

- **curried_summer.rb** explores partial function application in Ruby, specifically for inject patterns. Inject has argument order conducive to partial application, whereas the new each_with_object has the opposite order. This is the same issue scoreunder corrects in JS's underscore. 
- **monad_enumerable.rb** is left unfinished, but implements bind and unit.
- **refinements.rb** shows how half-implemented the real power of refinements are, without the ability to hit `Kernel#respond_to`.

To run the test yourself, clone this repo, cd into it, `bundle install`, then use `rspec filename.rb`.
