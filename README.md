Appraisal
=========

[![Build Status][Build Status Image]][Build Status]

Find out what your Ruby gems are worth.

[Build Status Image]: https://secure.travis-ci.org/thoughtbot/appraisal.png?branch=master
[Build Status]: http://travis-ci.org/thoughtbot/appraisal

Synopsis
--------

Appraisal integrates with bundler and rake to test your library against
different versions of dependencies in repeatable scenarios called "appraisals."
Appraisal is designed to make it easy to check for regressions in your library
without interfering with day-to-day development using Bundler.

Installation
------------

In your Gemfile:

    gem "appraisal"

Note that gems must be bundled in the global namespace. Bundling gems to a local
location or vendoring plugins is not supported. If you do not want to pollute the
global namespace, one alternative is [RVM's Gemsets](http://rvm.io/gemsets).

Setup
-----

Setting up appraisal requires an Appraisals file (similar to a Gemfile) in your
project root, named "Appraisals" (note the case), and some slight changes to
your project's Rakefile.

An Appraisals file consists of several appraisal definitions. An appraisal
definition is simply a list of gem dependencies. For example, to test with a
few versions of Rails:

    appraise "rails-3" do
      gem "rails", "3.2.14"
    end

    appraise "rails-4" do
      gem "rails", "4.0.0"
    end

The dependencies in your Appraisals file are combined with dependencies in your
Gemfile, so you don't need to repeat anything that's the same for each
appraisal. If something is specified in both the Gemfile and an appraisal, the
version from the appraisal takes precedence.

It's also recommended that you setup bundler at the very top of your Rakefile,
so that you don't need to constantly run bundle exec:

    require "rubygems"
    require "bundler/setup"

Usage
-----

Once you've configured the appraisals you want to use, you need to install the
dependencies for each appraisal:

    appraisal install

This will resolve, install, and lock the dependencies for that appraisal using
bundler. Once you have your dependencies set up, you can run any command in a
single appraisal:

    appraisal rails-3 rake test

This will run `rake test` using the dependencies configured for Rails 3. You can
also run each appraisal in turn:

    appraisal rake test

If you want to use only the dependencies from your Gemfile, just run `rake
test` as normal. This allows you to keep running with the latest versions of
your dependencies in quick test runs, but keep running the tests in older
versions to check for regressions.

In the case that you want to run all the appraisals by default when you run
`rake`, you can override your default Rake task by put this into your Rakefile:

    if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
      task :default => :appraisal
    end

(Appraisal sets `APPRAISAL_INITIALIZED` environment variable when it runs your
process. We put a check here to ensure that `appraisal rake` command should run
your real default task, which usually is your `test` task.)

Note that this may conflict with your CI setup if you decide to split the test
into multiple processes by Appraisal and you are using `rake` to run tests by
default. Please see **Travis CI Integration** for more detail.

Under the hood
--------------

Running `appraisal install` generates a Gemfile for each appraisal by combining
your root Gemfile with the specific requirements for each appraisal. These are
stored in the `gemfiles` directory, and should be added to version control to
ensure that the same versions are always used.

When you prefix a command with `appraisal`, the command is run with the
appropriate Gemfile for that appraisal, ensuring the correct dependencies
are used.

Version Control
---------------

When using Appraisal, we recommend you check in the Gemfiles that Appraisal
generates within the gemfiles directory, but exclude the lockfiles there
(`*.gemfile.lock`.) The Gemfiles are useful when running your tests against a
continuous integration server such as [Travis CI][Travis CI].

[Travis CI]: https://travis-ci.org

Travis CI integration
---------------------

If you're using Appraisal and using Travis CI, we're recommending you to setup
Travis to run the test against multiple generated Gemfiles. This can be done
by using `gemfile` setting:

    # In .travis.yml
    gemfile:
      - gemfiles/3.0.gemfile
      - gemfiles/3.1.gemfile
      - gemfiles/3.2.gemfile

Please note that if you've set your default rake task to run the test against
all versions of its dependency, you might have to set a `script` setting:

    script: "bundle exec rake test"

That will make sure that each of the test sub-job are not getting run more than
one time.

To run on all rubies / gemfiles, see [WWTD](https://github.com/grosser/wwtd)

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

Appraisal is maintained and funded by [thoughtbot, inc][thoughtbot]

Thank you to all [the contributors][contributors]

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

[thoughtbot]: http://thoughtbot.com/community
[contributors]: https://github.com/thoughtbot/appraisal/contributors

License
-------

Appraisal is Copyright © 2010-2013 Joe Ferris and thoughtbot, inc. It is free
software, and may be redistributed under the terms specified in the MIT-LICENSE
file.
