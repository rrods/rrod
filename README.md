<!--- TODO use consistent capitalization with Rrod and Riak as well as backticks-->
# Rrod
### Riak ruby object database.
Rrod lets you use the super awesome database, riak, to model and persist your
ruby objects.

## Riak Installation
First, you must make sure you 
[have Riak installed](http://docs.basho.com/riak/latest/quickstart/#Install-Riak).
These guys have extremely good docs and will usually answer your questions 
in freenode IRC #riak.  You must also make sure you have 
[enabled search](http://docs.basho.com/riak/latest/ops/advanced/configs/search/) 
for your Riak installation.  

## Rrod Installation
Add `rrod` to your Gemfile and run `bundle` or execute `gem install rrod`.

## Usage
Once you have Riak and Rrod installed you can begin to play.  `Rrod` will
connect to Riak on localhost using protocol buffers on port 8087.  What you
say? Don't worry about it.  

Next, in terminal, run:

```
$ rrod pry
```

This will set you up with an pry environment with `Rrod` loaded.  
Next you will wave your magic wand and enter the following incantations:

```ruby
Car = Class.new { include Rrod::Model }
car = Car.new(wheels: 5, color: 'black', make: 'Jeep')
car.save
@car = Car.find_first_by make: 'Jeep'
@car.wheels # => 5
```

`Rrod` lets you have arbitrary attributes on your ruby objects and persist and
retreive them from Riak.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
