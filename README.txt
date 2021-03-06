= utility_ranking

http://github.com/jdar/utility_ranking/tree/master

== DESCRIPTION:

conventions and cache-ability for utility_functions (which are otherwise computationally expensive and logically convoluted). works best on AR models.

== FEATURES/PROBLEMS:

* for some reason, you will need to include manually, at the bottom of the environment.rb file.
   add this line:      ActiveRecord::Base.send :include, UtilityRanking

== SYNOPSIS:

  although you can define 'utility' instance method for a given class, it is probably better to
  override any of the following methods:
     utility_cache
      utility_function

  let's face it. If your utility function wasn't db-intensive to calculate, you wouldn't be using this gem!

  the following methods are added.
#  => class << self   #competitors, #leaderboard
#  => #competitors, #leaderboard, #rank, #rank_amongst 

#  self.cache_utilities() depends on a)rails and b)returning a proc "utility_function" at the instance level

* ToDo
 re-implement instance-level leaderboard to return a special array of competitors... which array can also be querried for absolute ranking without re-querying the db or iterators. This would just be code spelunking / rubyfu / overkill.
 implement tests
 
* Code Samples

 @company.rank_amongst(Company.all) #=> 7
 @company.competitors #=>[array of competitor companies, including self]

 VehicleProducer.leaderboard(:class=>Company) #=> [ ... array of top 5 companies ... ] # :class option  
 @company.leaderboard will return the sorted top 5, and include @company as the 6th if not already.

- NB: rank_amongst() sometimes returns nil when given an array instead of a hash. The array was intended as a convenience method anyways, so quickfix is to always give competitors as a collection, using :collection=>[]

== REQUIREMENTS:

None(*)

* * This uses the rails-convention "find(:all, options)". But I have used this on non-rails by re-implementing. See /tests

== INSTALL:

add line within the Initialize block in environment.rb
  config.gem 'utility_ranking', :lib=>'utility_ranking', 
     :source => 'http://gems.github.com'
then run:
	rake gems:install

* for some reason, you will need to include manually, at the bottom of the environment.rb file (below the Initializer block).
   add this line:      ActiveRecord::Base.send :include, UtilityRanking

add the following two lines to your rankable model:
  utility_ranking
  def utility_function; lambda { self.id } end # change this!

optionally, add a utility_cache column for speed. AR classes will have #.cache_utilities now available.

== LICENSE:

(The MIT License)

Copyright (c) 2009 FIXME full name

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

txt EOF