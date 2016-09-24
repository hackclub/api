# You *must* specify versions for each dependency (this is a Hack Club
# convention, not an actual technical requirement)
source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg', '~> 0.18.4'
gem 'puma', '~> 3.0'

gem 'rack-cors', require: 'rack/cors'
gem 'faker', '~> 1.6'
gem 'geocoder', '~> 1.4'

group :development, :test do
  gem 'dotenv-rails', '~> 2.1'
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.7'
  gem 'shoulda', '~> 3.5'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
