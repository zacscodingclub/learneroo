== README

## The Automated Store by Learneroo

This is an empty Rails app that contains tests for a very simple online store.
Go through the following two tutorials and learn to build your first Rails app:

- [Rails - Model and Data](https://www.learneroo.com/modules/3)
- [Creating a Full Rails Site](https://www.learneroo.com/modules/131)

When you finish a section, enter `rake test` in your terminal to run the tests. The tests are configured to run in order and stop at the first failed test. If you pass all the tests you're supposed to - great! You can go on in the tutorial and continue passing tests. Otherwise, review the tutorial or look at the failed test and try to determine your error. If you're stuck, add a comment to the bottom of the Learneroo tutorial.

## How to re-create this app from scratch

See the second git commit for the steps to create this app. Here are some brief instructions:

1. Run `rails new your-app-name`
2. Add `config.generators.test_framework false` to application.rb
3. Update the gemfile: add two gems for Heroku, move sqlite3 to development, and add two new gems to development: minitest-fail-fast and learneroo-gem.
4. Copy the tests from this app to your own app's test folder. 
5. Add two lines near the top of test_helper:  
`require 'minitest/fail_fast' `  
`require 'learneroo_gem' `  