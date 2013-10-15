# Rrod
### Riak ruby object database.
Rrod lets you use the super awesome database, riak, to model and persist your
ruby objects.

# Riak
First, you must make sure you have Riak installed. See:
http://docs.basho.com/riak/latest/quickstart/#Install-Riak.
These guys have extremely good docs 
and will usually answer your questions in IRC #riak.  

## Installation
Add `rrod` to your Gemfile and run `bundle` or execute `gem install rrod`.

# Usage
Once you have riak and rrod installed, make sure you know the port of one of your
riak nodes.  Usually `8098`.

In terminal, run:

  $ rrod pry

This will set you up with an pry environment with rrod loaded.  Then run the
following commands.

```ruby
Car = Class.new { include Rrod::Model }
car = Car.new(wheels: 4, color: :black, make: 'Jeep')
car.save
@car = Car.find_by make: 'Jeep'
@car.wheels # => 4
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
