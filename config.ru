# frozen_string_literal: true
require 'rack/unreloader'
Unreloader = Rack::Unreloader.new{App}
require 'roda'
require_relative 'lib/ein'
Unreloader.require './app.rb'
run Unreloader

# run App.freeze.app
