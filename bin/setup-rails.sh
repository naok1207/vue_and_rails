rails new . -d=postgresql --skip-jbuilder -M -T --skip-bundle
sed -i 's/gem "tzinfo-data", platforms: %i\[ mingw mswin x64_mingw jruby \]/gem "tzinfo-data"/g' Gemfile
bundle install
bundle binstubs bundler
