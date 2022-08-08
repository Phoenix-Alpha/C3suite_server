# C3suite_server

Following are the necessary steps to get the application up and running.

## Install GPG

* Run the following commands:  
    $ brew install gpg  
    $ command curl -sSL https://rvm.io/mpapis.asc | gpg --import -

## Install RVM

* Run this command to install Ruby Version Manager :  
    $ \curl -L https://get.rvm.io | bash -s stable

* If u already have RVM installed then update to latest version :  
    $ rvm get stable --autolibs=enable

* Close and re-open the terminal for RVM to get installed completely.

## Install Ruby

* Run the following command to install ruby :  
    $ rvm install ruby-2.5.1

* Verify that the newest version of Ruby is installed :  
    $ ruby -v

## Check the Gem Manager

* Run  
    $ gem -v (Should be 3.0.6 or higher)

* update  
    $ gem update --system

* Display a list of gemsets   
    $ rvm gemset list

* RVM’s Global Gemset  
    $ rvm gemset use global  
    $ gem list

## Install Bundler

* Run  
    $ gem install bundler

* Install dependency for the gem  
    $ gem install nokogiri

## Install Rails

* Run  
    $ gem install rails

* Verify that the correct version of Rails is installed:  
    $ rails -v (Should be 5.2.2)

## Install Js packages

* Run
    $ yarn
    This will create node_modules folder in root dir. with all installed js packages

## Place .env file
    Place the .env file in root directoy

## Examine the code or run the application:

* Run  
    $ rails server

* Use your web browser to visit the application at http://localhost:3000
