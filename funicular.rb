###############################
# Setup a tidier gemfile
###############################

gem 'sass-rails'
gem 'haml-rails'
gem 'therubyracer',  platforms: :ruby
gem 'uglifier'
gem 'rake-n-bake'

gem_group :development, :test do
  gem 'spring'
  gem 'pry-byebug'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'meta_request'
  gem 'metric_fu', require: false
  gem 'rubocop', require: false
  gem 'sandi_meter', require: false
  gem 'web-console'
end

gem_group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
end

gem_group :development do
  gem 'coffee-rails-source-maps'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'bullet'
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'guard-bundler', require: false
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'erb2haml'
end


###############################
# Remove some default cruft
###############################

run "rm README.rdoc"
gsub_file 'Gemfile', /#.*\n/, ''

# So long, turbolinks
gsub_file 'Gemfile', /gem 'turbolinks.*\n/, ""
gsub_file 'app/assets/javascripts/application.js', /\/\/= require turbolinks.*\n/, ""
gsub_file 'app/views/layouts/application.html.erb', ", 'data-turbolinks-track' => true", ''

# Addios, JQuery
gsub_file 'Gemfile', /gem 'jquery.*/, ""
gsub_file 'app/assets/javascripts/application.js', /\/\/= require jquery.*\n/, ""

###############################
# Setup some nice things
###############################

after_bundle do
  generate(:'rspec:install')

  inject_into_file 'spec/rails_helper.rb', after: /config.fixture_path.*\n/ do <<-RUBY
    config.include FactoryGirl::Syntax::Methods
    RUBY
  end

  ###############################
  # Pull into the station
  ###############################

  rake "haml:replace_erbs"

  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
  say 'Inital commit created'

  rake 'db:create db:setup'


  puts '                    /\ '
  puts '                   /  \ '
  puts '                  /    \ '
  puts '                 /      ^^\ '
  puts '                /          \ '
  puts '               /\/\/\/\/\/\/\ '
  puts '              /              \ '
  puts '             /                \ '
  puts '            /                  \ '
  puts '           ----------------------'
  puts 'Thank you for choosing the DevMountain Funicular Rails-way!'
end