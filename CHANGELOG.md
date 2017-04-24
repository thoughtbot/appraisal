# Change Log

## [Unreleased](https://github.com/thoughtbot/appraisal/tree/HEAD)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v1.0.2...HEAD)

**Closed issues:**

- appraisal install problem with finding bundler gem [\#87](https://github.com/thoughtbot/appraisal/issues/87)

- Make sure that relativize supports :path that is CWD \("."\) [\#82](https://github.com/thoughtbot/appraisal/issues/82)

- Add `-v` and `--version` to CLI [\#80](https://github.com/thoughtbot/appraisal/issues/80)

- DSL aliases mixed up? [\#78](https://github.com/thoughtbot/appraisal/issues/78)

- Appraisal doesn't support gemspec inside group [\#76](https://github.com/thoughtbot/appraisal/issues/76)

- Dependency conflict [\#75](https://github.com/thoughtbot/appraisal/issues/75)

**Merged pull requests:**

- Allow commands with spaces to be constructed as new Commands [\#86](https://github.com/thoughtbot/appraisal/pull/86) ([mcmire](https://github.com/mcmire))

- uniq Gemfile\#source [\#85](https://github.com/thoughtbot/appraisal/pull/85) ([razum2um](https://github.com/razum2um))

- Enable bundler caching in Travis [\#81](https://github.com/thoughtbot/appraisal/pull/81) ([oliverklee](https://github.com/oliverklee))

- \[TASK\] Configure Travis for better build performance [\#79](https://github.com/thoughtbot/appraisal/pull/79) ([oliverklee](https://github.com/oliverklee))

- Fully DSL support inside group [\#77](https://github.com/thoughtbot/appraisal/pull/77) ([maxlinc](https://github.com/maxlinc))

## [v1.0.2](https://github.com/thoughtbot/appraisal/tree/v1.0.2) (2014-08-22)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v1.0.1...v1.0.2)

**Closed issues:**

- Appraisal should overwrite Gemfile specs with Appraisal specs [\#72](https://github.com/thoughtbot/appraisal/issues/72)

- Transition from a library to a program [\#70](https://github.com/thoughtbot/appraisal/issues/70)

## [v1.0.1](https://github.com/thoughtbot/appraisal/tree/v1.0.1) (2014-08-22)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v1.0.0...v1.0.1)

**Merged pull requests:**

- Add 'list' subcommand to CLI [\#74](https://github.com/thoughtbot/appraisal/pull/74) ([opsidao](https://github.com/opsidao))

- wwtd [\#73](https://github.com/thoughtbot/appraisal/pull/73) ([grosser](https://github.com/grosser))

- Updating CLI for MRI 1.8 friendliness [\#71](https://github.com/thoughtbot/appraisal/pull/71) ([pat](https://github.com/pat))

## [v1.0.0](https://github.com/thoughtbot/appraisal/tree/v1.0.0) (2014-04-02)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v1.0.0.beta3...v1.0.0)

**Closed issues:**

- Migrate Cucumber to RSpec test files [\#63](https://github.com/thoughtbot/appraisal/issues/63)

- Appraisal::Gemfile doesn't support Bundler platforms block syntax [\#51](https://github.com/thoughtbot/appraisal/issues/51)

- Support gemspec in Appraisals [\#48](https://github.com/thoughtbot/appraisal/issues/48)

- Support git syntax in Appraisals [\#47](https://github.com/thoughtbot/appraisal/issues/47)

## [v1.0.0.beta3](https://github.com/thoughtbot/appraisal/tree/v1.0.0.beta3) (2014-02-28)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v1.0.0.beta2...v1.0.0.beta3)

**Closed issues:**

- Better documentation on README [\#68](https://github.com/thoughtbot/appraisal/issues/68)

**Merged pull requests:**

- Added platforms support [\#69](https://github.com/thoughtbot/appraisal/pull/69) ([jwaldrip](https://github.com/jwaldrip))

## [v1.0.0.beta2](https://github.com/thoughtbot/appraisal/tree/v1.0.0.beta2) (2013-11-06)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v1.0.0.beta1...v1.0.0.beta2)

**Closed issues:**

- Appraisal requires a version of Thor that is too recent [\#67](https://github.com/thoughtbot/appraisal/issues/67)

## [v1.0.0.beta1](https://github.com/thoughtbot/appraisal/tree/v1.0.0.beta1) (2013-10-29)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.5.2...v1.0.0.beta1)

**Closed issues:**

- Add ability to specify `--jobs` size for `bundle install` [\#62](https://github.com/thoughtbot/appraisal/issues/62)

- `bundle check || bundle install` fails if `bundle update` needs to be run [\#60](https://github.com/thoughtbot/appraisal/issues/60)

- If gemspec and Gemfile are used in regular project, declaration matters [\#58](https://github.com/thoughtbot/appraisal/issues/58)

- Complain if no Appraisals file [\#56](https://github.com/thoughtbot/appraisal/issues/56)

- appraisal:install doesn't work if bundler installs gems inside the project [\#55](https://github.com/thoughtbot/appraisal/issues/55)

- Impossible to use as a default rake task [\#54](https://github.com/thoughtbot/appraisal/issues/54)

- rake appraisal:relativize [\#49](https://github.com/thoughtbot/appraisal/issues/49)

- Don't ignore Bundler groups [\#35](https://github.com/thoughtbot/appraisal/issues/35)

**Merged pull requests:**

- Add description of known Bundle installation limitation. [\#66](https://github.com/thoughtbot/appraisal/pull/66) ([phillbaker](https://github.com/phillbaker))

- Introducing `appraisal` CLI [\#64](https://github.com/thoughtbot/appraisal/pull/64) ([sikachu](https://github.com/sikachu))

- Add bundler parallel install option [\#61](https://github.com/thoughtbot/appraisal/pull/61) ([sanemat](https://github.com/sanemat))

- Command determines ARGV correctly when ARGV empty [\#59](https://github.com/thoughtbot/appraisal/pull/59) ([mcmire](https://github.com/mcmire))

- Complain if no Appraisals file is found. [\#57](https://github.com/thoughtbot/appraisal/pull/57) ([padi](https://github.com/padi))

- Drop support for 1.8.7 [\#53](https://github.com/thoughtbot/appraisal/pull/53) ([mike-burns](https://github.com/mike-burns))

- Let the gem know it is MIT licensed [\#52](https://github.com/thoughtbot/appraisal/pull/52) ([bf4](https://github.com/bf4))

- make relativize task available [\#50](https://github.com/thoughtbot/appraisal/pull/50) ([grosser](https://github.com/grosser))

- Add necessary newline and remove excess newline [\#46](https://github.com/thoughtbot/appraisal/pull/46) ([sanemat](https://github.com/sanemat))

## [v0.5.2](https://github.com/thoughtbot/appraisal/tree/v0.5.2) (2013-04-05)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.5.1...v0.5.2)

**Closed issues:**

- Cannot install gems in generated gemfiles [\#42](https://github.com/thoughtbot/appraisal/issues/42)

**Merged pull requests:**

- Remove interpreter warnings [\#45](https://github.com/thoughtbot/appraisal/pull/45) ([kachick](https://github.com/kachick))

- Replace `source :rubygems` with url for rubygems.org [\#44](https://github.com/thoughtbot/appraisal/pull/44) ([tricknotes](https://github.com/tricknotes))

- Update copyright year to 2013 [\#43](https://github.com/thoughtbot/appraisal/pull/43) ([adarsh](https://github.com/adarsh))

## [v0.5.1](https://github.com/thoughtbot/appraisal/tree/v0.5.1) (2012-11-07)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.5.0...v0.5.1)

**Closed issues:**

- Please do a \> 0.4.1 release of appraisal [\#40](https://github.com/thoughtbot/appraisal/issues/40)

**Merged pull requests:**

- Keep dots when generating a Gemfile [\#41](https://github.com/thoughtbot/appraisal/pull/41) ([gabebw](https://github.com/gabebw))

## [v0.5.0](https://github.com/thoughtbot/appraisal/tree/v0.5.0) (2012-10-31)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.4.1...v0.5.0)

**Closed issues:**

- undefined method `dirname' for Appraisal::File:Class [\#39](https://github.com/thoughtbot/appraisal/issues/39)

- rake apraisal:bundle --\> fast check or bundle if necessary [\#32](https://github.com/thoughtbot/appraisal/issues/32)

- Appraisal with vendorized gems [\#30](https://github.com/thoughtbot/appraisal/issues/30)

- Can't get Appraisal to work on Travis CI [\#25](https://github.com/thoughtbot/appraisal/issues/25)

- shoulda \(2.11.3\) needs to be added as a development dependcy [\#20](https://github.com/thoughtbot/appraisal/issues/20)

- Appraisal should not create multiple lines for the same gem entry [\#3](https://github.com/thoughtbot/appraisal/issues/3)

**Merged pull requests:**

- check and only install if necessary -\> faster + less output [\#38](https://github.com/thoughtbot/appraisal/pull/38) ([grosser](https://github.com/grosser))

- ignore gemfile.lock since that is what was inntended by not checking it in [\#37](https://github.com/thoughtbot/appraisal/pull/37) ([grosser](https://github.com/grosser))

- Whitespace etc [\#36](https://github.com/thoughtbot/appraisal/pull/36) ([gabebw](https://github.com/gabebw))

- How to hit 1.0.0 [\#34](https://github.com/thoughtbot/appraisal/pull/34) ([mike-burns](https://github.com/mike-burns))

- Cruise aka fast-install-without-troubles [\#33](https://github.com/thoughtbot/appraisal/pull/33) ([grosser](https://github.com/grosser))

- Bundler's group method can take multiple group names [\#31](https://github.com/thoughtbot/appraisal/pull/31) ([rafaelfranca](https://github.com/rafaelfranca))

- Bundler's group method can take multiple group names, appraisal breaks this [\#29](https://github.com/thoughtbot/appraisal/pull/29) ([adelcambre](https://github.com/adelcambre))

- Fix failing tests due to missing shoulda dependency [\#28](https://github.com/thoughtbot/appraisal/pull/28) ([gregors](https://github.com/gregors))

- clean the name before dumping to filesystem [\#27](https://github.com/thoughtbot/appraisal/pull/27) ([osheroff](https://github.com/osheroff))

- fix for Appraisal breaking when path contains spaces [\#26](https://github.com/thoughtbot/appraisal/pull/26) ([gregors](https://github.com/gregors))

- Grammar correction [\#24](https://github.com/thoughtbot/appraisal/pull/24) ([bcardarella](https://github.com/bcardarella))

- Added support for rewritting of the :path option on gem [\#19](https://github.com/thoughtbot/appraisal/pull/19) ([scottdavis](https://github.com/scottdavis))

## [v0.4.1](https://github.com/thoughtbot/appraisal/tree/v0.4.1) (2012-02-15)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.4.0...v0.4.1)

**Closed issues:**

- Appraisals Support For Platforms [\#21](https://github.com/thoughtbot/appraisal/issues/21)

- Could not find bundler \(\>=0\) [\#13](https://github.com/thoughtbot/appraisal/issues/13)

**Merged pull requests:**

- Support ENV\['BUNDLE\_GEMFILE'\] variable [\#23](https://github.com/thoughtbot/appraisal/pull/23) ([radar](https://github.com/radar))

- Indicate that the Appraisals file must be named "Appraisals" \(case sensi... [\#22](https://github.com/thoughtbot/appraisal/pull/22) ([kategengler](https://github.com/kategengler))

## [v0.4.0](https://github.com/thoughtbot/appraisal/tree/v0.4.0) (2011-11-11)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.3.8...v0.4.0)

**Closed issues:**

- Development dependencies can't be overridden [\#16](https://github.com/thoughtbot/appraisal/issues/16)

- Am I supposed to check in gemfiles/\*.lock? [\#12](https://github.com/thoughtbot/appraisal/issues/12)

- Appraisal does not support symbolic gem sources [\#8](https://github.com/thoughtbot/appraisal/issues/8)

- Running appraisal:install for different versions of Ruby rearranges gemfile entries [\#7](https://github.com/thoughtbot/appraisal/issues/7)

- Support for group in Gemfile [\#6](https://github.com/thoughtbot/appraisal/issues/6)

**Merged pull requests:**

- Symbolic sources [\#18](https://github.com/thoughtbot/appraisal/pull/18) ([jferris](https://github.com/jferris))

- Preserve order in gemfiles [\#17](https://github.com/thoughtbot/appraisal/pull/17) ([jferris](https://github.com/jferris))

- Gemspec source as symbol [\#15](https://github.com/thoughtbot/appraisal/pull/15) ([flavorjones](https://github.com/flavorjones))

- Including factory\_girl and mocha as dev dependencies in the gemspec. [\#14](https://github.com/thoughtbot/appraisal/pull/14) ([flavorjones](https://github.com/flavorjones))

- Spike group support [\#11](https://github.com/thoughtbot/appraisal/pull/11) ([technicalpickles](https://github.com/technicalpickles))

- Fix source\_entry to work with sources like :rubygems [\#10](https://github.com/thoughtbot/appraisal/pull/10) ([technicalpickles](https://github.com/technicalpickles))

## [v0.3.8](https://github.com/thoughtbot/appraisal/tree/v0.3.8) (2011-08-09)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.3.5...v0.3.8)

**Closed issues:**

- Relative gemfiles location breaks cucumber tests with aruba [\#5](https://github.com/thoughtbot/appraisal/issues/5)

- undefined method `expand\_path' for Appraisal::File:Class [\#4](https://github.com/thoughtbot/appraisal/issues/4)

**Merged pull requests:**

- Aruba should not be a runtime dep [\#9](https://github.com/thoughtbot/appraisal/pull/9) ([betamatt](https://github.com/betamatt))

## [v0.3.5](https://github.com/thoughtbot/appraisal/tree/v0.3.5) (2011-05-31)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.3.4...v0.3.5)

## [v0.3.4](https://github.com/thoughtbot/appraisal/tree/v0.3.4) (2011-05-30)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.3.3...v0.3.4)

## [v0.3.3](https://github.com/thoughtbot/appraisal/tree/v0.3.3) (2011-05-27)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.3.2...v0.3.3)

## [v0.3.2](https://github.com/thoughtbot/appraisal/tree/v0.3.2) (2011-05-25)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.3.1...v0.3.2)

## [v0.3.1](https://github.com/thoughtbot/appraisal/tree/v0.3.1) (2011-05-24)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.3.0...v0.3.1)

**Merged pull requests:**

- Support for gemspec [\#2](https://github.com/thoughtbot/appraisal/pull/2) ([josephholsten](https://github.com/josephholsten))

## [v0.3.0](https://github.com/thoughtbot/appraisal/tree/v0.3.0) (2011-05-24)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.2.0...v0.3.0)

**Closed issues:**

- Add support for the gemspec directive [\#1](https://github.com/thoughtbot/appraisal/issues/1)

## [v0.2.0](https://github.com/thoughtbot/appraisal/tree/v0.2.0) (2011-05-23)

[Full Changelog](https://github.com/thoughtbot/appraisal/compare/v0.1...v0.2.0)

## [v0.1](https://github.com/thoughtbot/appraisal/tree/v0.1) (2010-11-11)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*