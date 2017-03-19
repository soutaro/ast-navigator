# AST::Navigator

`AST::Navigator` provides some utility functions for `AST::Node` objects, including *parent(node)*, *ancestors(node)*, *siblings(node)*.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ast-navigator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ast-navigator

## Usage

```rb
require "ast/navigator"

navigator = AST::Navigator.new()

# Add root node to navigator
navigator.add_root_node(node)

# Returns parent node or nil
navigator.parent(node.children[0])

# Returns array of ancestor nodes
navigator.ancestors(node.children[0].children[1].children[3])

# Yields child node of given node, non AST::Node children will be ignored
navigator.each_child(node) do ... end

# Yields sibling nodes of given node, non AST::Node siblings will be ignored
navigator.each_sibling(node) do ... end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/soutaro/ast-navigator.

