---
title: Intro to Jekyll
permalink: /docs/intro/
---
Jekyll is a blog aware static site generator

Jekyll on Ubuntu

Before we install Jekyll, we need to make sure we have all the required dependencies.

`sudo apt-get install ruby-full build-essential zlib1g-dev`

It is best to avoid installing Ruby Gems as the root user. Therefore, we need to set up a gem installation directory for your user account. The following commands will add environment variables to your ~/.bashrc file to configure the gem installation path. Run them now:

`echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc`
`echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc`
`echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc`
`source ~/.bashrc`

Finally, install Jekyll:

`gem install jekyll bundler`

That’s it! You’re ready to start using Jekyll.

#creating a jekyll project
`jekyll new myblog`
`cd myblog `
`jekyll serve or bundle exec jekyll serve `

if you are doing it on an existing jekyll and 
bundle exec jekyll serve is giving an error 
then open the Gemfile.lock file and check the bundler version 


Then install bundler this way
`gem install -v "1.5.4"`

and run the following commands

`bundle install`
`bundle exec jekyll serve`