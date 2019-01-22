require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper.rb'

# puts Townhall.all
Townhall.save_as_JSON
Townhall.save_as_spreadsheet
Townhall.save_as_csv
