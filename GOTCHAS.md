## Rails Tidbits

Finally got around to writing a helpful readme for little gotchyas in web programming that I always forget:

# Git

* Ammended a commit: `git commit --amend -C HEAD`
* Untrack file: `git rm --cached filename`
* Pull remote branch: `git checkout --track origin/branch_name`
* Delete a branch: `git branch -d local_only_branch`
* Delete a remote branch: `git push origin --delete remote_branch`
* Remove files after adding to `.gitignore`: `git rm -r --cached some-directory`
* Diffing two branches: `git diff branch_1..branch_2`
* Undoing a commit: `git reset --soft HEAD~1`
* Unstaging a file: `git reset <filename>`
* Finding a bad commit:

```
git bisect start <good-sha> <bad-sha>
git bisect run <cmd> <args>
```

## Renaming branches

  git branch -m old_branch new_branch         # Rename branch locally    
  git push origin :old_branch                 # Delete the old branch    
  git push --set-upstream origin new_branch   # Push the new branch, set local branch to track the new remote

## Git Rebase

* http://nathanleclaire.com/blog/2014/09/14/dont-be-scared-of-git-rebase/

### Editing Commits w/ Rebase

* `git rebase -i` and set commit to `edit` over `pick`

## Git SVN

* Checkout remote branch: `git checkout -b <branch-name>-svn remotes/origin/<branch-name>`
* Going from a local feature branch to a remote SVN branch:

```shell
svn cp <url-to-svn-repo>/trunk <url-to-svn-repo>/branches/final-remote-name -m "<message>"
git svn fetch    # Sync w/ remote svn repo.
git branch -r    # This should list final-remote-name.

git checkout local-feature-branch   # This is the local branch where your prototype feature is committed.
git svn info     # This will say you are following trunk.
git rebase remotes/origin/final-remote-name


git log         # All of your feature commits should be on top, followed by the commit that created the svn branch, followed by trunk commits.
git svn info    # This should now say you are following the svn branch, final-remote-name.

git svn dcommit
```

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

# Databases / Migrations

* [Index foreign keys](https://tomafro.net/2009/08/using-indexes-in-rails-index-your-associations) - also has some stuff about polymorphism

# Ruby Syntax

* To cast objects safely to an array, user `Array(object)`
* Iterating over arrays in parallel:

    array1.zip(array2).each do |elem1, elem2| 
    end

* Accessing object attributes programatically:
   obj = Model.first, attr = :my_attr
   obj[attr] == Model.first.my_attr

* Downcasing: `string.downcase`
* Suppressing stdout: $stdout = File.open(File::NULL, 'w')

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

# Search + Replace

* `:vimgrep /path_to_command/gj ./**/*.rb`
* `perl -pi -w -e 's/SEARCH_FOR/REPLACE_WITH/g;' *.txt`
* Use `grep -A5` or `grep -B3` to return 5 lines after or 3 lines before a matching line
* Open results from `grep` in vim: `grep -ilr <pattern> | xargs vim -o`

# Finding files

* Find all files recursively: `find $PWD -name '*.js'`

# Acting on all files recursively: `for FILE in `find app/assets/javascripts/ -name '*.js'`; do <action> ; done`

# Gems

* Remove all gems: http://ruby-journal.com/how-to-uninstall-all-ruby-gems/
* Making gems: http://guides.rubygems.org/make-your-own-gem/
* Build a gem: `gem build <gemname>.gemspec`

# Vim

* Autowrap text to 80 lines: In Visual mode, type `gq`
* Remove meta characters: `set ff=unix`
* Remove trailing whitespace: `%s:\s\+$`

# Deploying (Juniper)

```
cd /tmp
svn co https://tt-svn.juniper.net/svn/adp/projects/lrm/core/trunk lrm_trunk
cd lrm_trunk
bundle install
```

# cURL

```
while [[ `curl --fail -X POST -H "Content-Type: application/json" -d
'{"health_event": {"comment": "Successfully updated resource 120567",
"event_type": "SWEEP_OK", "resource_name": "coney"}, "_flat":true }'
http://localhost:3000/lrm/core/health_event.json?_flat` ]]
do
  echo "SUCCESS"
done
```

# Print over SSH

* `cat filename | ssh host "lp -d destination -n copies -"`
* e.g. `cat RoseRoyaltyEmceeScript.pdf | ssh jpfosi01@homework.cs.tufts.edu "lp -d hp116 -n 1 -"`

# SSH Keys

* http://www.ece.uci.edu/~chou/ssh-key.html
* http://www.cyberciti.biz/faq/how-to-set-up-ssh-keys-on-linux-unix/

# Checking file descriptor limits (on Linux)

* System-wide: `cat /proc/sys/fs/file-max`
* User-specific: `limit` or `ulimit`

# CMake

* Basic debug build:

```shell
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug ..
make
```

* Adding flags: `set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG=1")`

# tmux

* Start a new tmux session in "control" mode which allows scrolling: `tmux -CC`
* Detach by pressing Esc
* Reattach to a running session `tmux -CC a`
* Attach to session w/ different winow: `tmux new-session -t <id>`
* Cycle through layouts: `prefix + Space`

# Python

* Great explanation of iterables vs generators: http://nvie.com/posts/iterators-vs-generators/

# GDB

* Clearing breakpoints: `clear <function|lineno>`
* Conditional breakpoints: `b <break> if <cond>`
* List threads: `info threads`
* Switch threads: `thread <thread-id>`

# Netstat

* Determine which program is using which port `sudo netstat -tulpn`

# Finding a list of files in vim

```
:% ! while read f; do find /src/Bgp -name $f; done
```

# Locate

* Using Unix tool `locate` to find files
* `locate -ir "my_file.*log"` - using regex
* Populating indices: `sudo /etc/cron.daily/mlocate.cron`
