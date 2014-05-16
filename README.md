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
[enabled Secondary Indexing](http://docs.basho.com/riak/latest/ops/advanced/configs/secondary-index/) 
for your Riak installation.  

## Rrod Installation
Add `rrod` to your Gemfile and run `bundle` or execute `gem install rrod`.

## Usage
Once you have Riak and Rrod installed you can begin to play.  `Rrod` will
connect to Riak on localhost using protocol buffers on port 8087.  What you
say? Don't worry about it.  

Next, if you installed Rrod by adding it to your Gemfile, run

```
$ bundle exec rrod pry
```

Otherwise, if you installed using `gem install rrod`, run:

```
$ rrod pry
```

This will set you up with an pry environment with `Rrod` loaded.  
Next you will wave your magic wand and enter the following incantations:

```ruby
class Person
  attribute :name, String,  index: true
  attribute :age,  Integer, index: true
end

hank = Person.new(name: "Hank", age: 40)
hank.save

@hank = Person.find_by name: "Hank"
@hank.age # => 40
```

`Rrod` lets you have arbitrary attributes on your ruby objects and persist and
retreive them from Riak.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
