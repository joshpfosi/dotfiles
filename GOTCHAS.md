## Rails Tidbits

Finally got around to writing a helpful readme for little gotchyas in web programming that I always forget:

# Git

* Ammended a commit: `git commit --amend -C HEAD`
* Untrack file: `git rm --cached filename`
* Pull remote branch: `git checkout --track origin/branch_name`
* Delete a branch: `git branch -d local_only_branch`
* Delete a remote branch: `git push origin --delete remote_branch`

# RSpec

* Installing: `gem 'rspec-rails'`, `bundle`, `rails g rspec:install` and copy appropriate contents from previous `spec/spec_helper` and `spec/support`
* Always have at least byebug for debugging (`gem 'byebug'`)
* `Unknown Format` error in RSpec means add `format: :json` to whatever request is giving the error
* Add to `config/environments/test.rb` to suppress all those SQL statements

    # suppress SQL logging on success
    config.log_level = :error

* The `let` statement is lazily evaluated (not called until used inside a test). Use `let!` to force evaluation.

* Precompile assets prior to running suite. Useful for Capybara integration tests
```
RSpec.configure do |config|
  config.before :all do
    ENV['PRECOMPILE_ASSETS'] ||= begin
      case self.class.metadata[:type]
      when :feature, :view
        STDOUT.write "Precompiling assets..."
        Sprockets::StaticCompiler.new(
          Rails.application.assets,
          File.join(Rails.public_path, Rails.configuration.assets.prefix),
          Rails.configuration.assets.precompile,
          manifest_path: Rails.configuration.assets.manifest,
          digest: Rails.configuration.assets.digest,
          manifest: false).compile
        STDOUT.puts " done."
        Time.now.to_s
      end
    end
  end
end
```

# QUnit/Ember/Rails

* Add `gem 'ember-qunit-rails'` and `//= require ember-qunit` to `application.js`

# Databases / Migrations

* [Index foreign keys](https://tomafro.net/2009/08/using-indexes-in-rails-index-your-associations) - also has some stuff about polymorphism

# Delayed::Job

* Use an initializer in `config/initializers/delayed_job.rb` defined as:

    # when launched with rake, RAILS_ENV is nil
    if ENV["RAILS_ENV"].present? && ENV["RAILS_ENV"] != "test"
      require 'archive'
      Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
    
      # schedule recurring jobs
      Archive.schedule! # schedule recurring job defined in lib/archive.rb
    end

# Ruby Syntax

* To cast objects safely to an array, user `Array(object)`
* Iterating over arrays in parallel:

    array1.zip(array2).each do |elem1, elem2| 
    end

* Accessing object attributes programatically:
   obj = Model.first, attr = :my_attr
   obj[attr] == Model.first.my_attr

* Downcasing: `string.downcase`

# FactoryGirl

* [Callbacks](http://robots.thoughtbot.com/aint-no-calla-back-girl)

# Rails

* `save(validate: false)` ignores validations

# Ember CLI

* Use `ember-cli-bootstrap` for Bootstrap + Glyphicons, with Brocfile change to import javascript - perhaps, not true

# Heroku

* Use `heroku pg:reset DATABASE_URL --app appname` to reset the database

# Errors

* Stack level too deep in controllers => Check the serializer to make sure you are not looping there

# Git Rebase

* http://nathanleclaire.com/blog/2014/09/14/dont-be-scared-of-git-rebase/

# Search + Replace

* `:vimgrep /path_to_command/gj ./**/*.rb`
* `perl -pi -w -e 's/SEARCH_FOR/REPLACE_WITH/g;' *.txt`

# Gems

* Remove all gems: http://ruby-journal.com/how-to-uninstall-all-ruby-gems/
* Making gems: http://guides.rubygems.org/make-your-own-gem/

# Git SVN

* Checkout remote branch: `git checkout -b <branch-name>-svn remotes/origin/<branch-name>`
