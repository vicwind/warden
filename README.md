Warden is created to aim at better managed running automated test cases that's written using Cucumber and Capybara for multiple web application projects. It tries to leverage a proofed working pattern to organize test logic, test data, and naming mapping to help managing a large QA project that usually contains hundreds of test cases.

By following the gradually modularization work flow: Record and play back -> enhance to script for robustness and add test logic and data separation -> modularize commonly used steps -> maximize modularization using page objects, we hope Warden will help us implement test case as fast as developing features and also lower the costs of maintaining constant changes of a evolving web application.

## Warden Architecture

Still in its early stage, only the core framework and the support to run test on Sauce Labs is finished, other components will be actively work on after the core is finished and guarded by tests.
![Warden Architecture Diagram](https://github.com/vicwind/warden/raw/master/etc/warden_architecture.jpg)

## Requirement and Setup

Warden is developed on Mac OS 10.6.8 using ruby 1.9.2p290, cucumber (1.1.4), capybara (1.1.2) and rspec (2.7.0). It should be able to run on other Linux/Unix platforms without problems(the headache is more on getting Firefox or Google Chrome installed working).

* Install Ruby 1.9.2 through [RVM](http://beginrescueend.com/rvm/install/).
* Install Bundler `gem install bundler`, and install all the require gems by doing `bundle install`
** (you may need to install native pkg for QT([QT install help](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit)) and libcurl-devel
* Setup WARDEN_CONFIG_DIR & WARDEN_HOME environment variables in the `<warden dir>/.rvmrc` file to point the project root dir and it’s config dir

```bash
Example:
export WARDEN_HOME=/Users/victor/work/warden_fw
export WARDEN_CONFIG_DIR=$WARDEN_HOME/config
```

* Test run your setup:
  * try to run Cucumber
`cucumber project/test_project/features/buying_guide.feature`
  * if the feature ran and you see a Firefox browser pop-up, Cheers! your setup is successful, we can start our journey of developing test features!

## Create a New Test Project (Amazon Book Search)
* Create a scaffolding of the new project 

```console
bash <warden root>/bin/create_project.sh amazon_search_test
```

* It will create a project skeletons like the following in the created project directory

```console
drwxr-xr-x  2 victor  staff   68 Feb 26 15:55 etc # other project related assets, eg. locale.yml
drwxr-xr-x  3 victor  staff  102 Feb 26 15:55 features #all the feature files go here and the feature steps 
drwxr-xr-x  2 victor  staff   68 Feb 26 15:55 lib #other helper libs we will use in the project
```

* Edit the `<warden root>/config/app_env.yaml` file. add an entry under development section

```yaml
#for this example, we added amazon_serach_test and it's URL. all the features in the project will start with that url
  development: 
    'amazon_search_test': http://www.amazon.com/
```

* Edit the `<test project dir>/features/project_init.rb` file, and do the following change

```bash
require "#{ENV['WARDEN_HOME']}/config/env"
#add more "require" statements here, if you need to uses other gem or ruby libs
ENV["WARDEN_TEST_TARGET_ENV"] = "prd" #change this to "development", remember the app_env.yaml? we set the right url in the "development" environment but not the "prd" environment yet.
ENV["WARDEN_TEST_TARGET_NAME"] = 'amazon_search_test'
ENV["WARDEN_DEBUG_MODE"] = "false" #set it to "true" if you want to go into ruby debug mode when the test case fail
ENV['WARDEN_RUN_MODE'] = 'local'
..
...
```

* Open your favorite editor and create your every first Cucumber feature file :) create the new file in the "features" directory `<project root>/features/test_search.feature`

```cucumber
Feature:
  Test Amazon's product search feature
  Scenario: a simple book search
    Given  The user has changed to the default test target environment for the test application
    When the user type "taking people with you" in the search bar and click "Go"
    Then the user should see some result on the page
    Then check if "Taking People With You" is in the search result
```

* Run the feature: `cucumber ./test_search.feature`
* Cucumber will take you that you have undefined steps. create an new step files `<project root>/features/test_search_steps.rb`
* Copy the Cucumber suggested steps definition to the file

```ruby
When /^the user type "([^"]*)" in the search bar and click "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end
Then /^the user should see some result on the page$/ do
  pending # express the regexp above with the code you wish you had
end
Then /^check if "([^"]*)" is in the search result$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
```

* Let's implement the steps using Capybara's [API](http://rubydoc.info/github/jnicklas/capybara) and look at its [Github page](https://github.com/jnicklas/capybara) for help. (you can just copy/paste as i have done the hard work for you already :) )

```ruby
When /^the user type "([^"]*)" in the search bar and click "([^"]*)"$/ do |arg1, arg2|
  fill_in 'twotabsearchtextbox', :with=> arg1
  click_button arg2
end
Then /^the user should see some result on the page$/ do
  result_set = find :id, 'atfResults'
  #have more than one result the set
  result_set.all(:css, 'div[id^=result]').size.should >= 1
end
Then /^check if "([^"]*)" is in the search result$/ do |arg1|
  find(:id, 'atfResults').text.should include(arg1)
end
```

* Save the file and rerun the feature file again, <code>cucumber ./test_search.feature</code>. You will see your test go GREEN!

```console
wb-preset:features victor$ cucumber ./test_search.feature
Feature: 
  Test Amazon's product search feature
  Scenario: a simple book search                                                               # ./test_search.feature:3
    Given The user has changed to the default test target environment for the test application # /Users/victor/work/warden_fw/lib/lib_steps.rb:31
    When the user type "taking people with you" in the search bar and click "Go"               # test_search_steps.rb:1
    Then the user should see some result on the page                                           # test_search_steps.rb:6
    Then check if "Taking People With You" is in the search result                             # test_search_steps.rb:12
1 scenario (1 passed)
4 steps (4 passed)
0m14.256s
```

* You have now successfully created you first project and first feature with Cucumber Capybara. It's up to you now to conquer the rest of "world" of your test project. For more help and other feature of Warden you can go to the [Wiki pages](https://github.com/vicwind/warden/wiki)

