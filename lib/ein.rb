# frozen_string_literal: true

require 'http'
require 'zipruby'
require 'csv'
require 'singleton'
require 'dbm'

class EIN
  DB_FILENAME = '.ein.db'
  include Singleton

  attr_accessor :data

  def initialize url: 'https://apps.irs.gov/pub/epostcard/data-download-pub78.zip'

    if File.exist? DB_FILENAME
      @db = DBM.open DB_FILENAME, 0666, DBM::WRITER
    else
      @db = DBM.open DB_FILENAME, 0666, DBM::NEWDB
      data = parse unzip download url
      data.each { |k, v| @db[k] = v }
    end
  end

  def find ein
    [ein, @db[ein]]
  end

  def inspect
    "#<#{self.class.name}:#{@db.size} cached>"
  end

  private

  def download url
    puts "Downloading #{url} ..."
    HTTP.follow.get(url).to_s
  end

  def unzip zip
    puts 'Unzipping data ...'
    Zip::Archive.open_buffer(zip) { |archive| archive.map(&:read).join }
  end

  def parse data
    puts 'Parsing data ...'
    CSV.new(data, col_sep: '|').reject &:empty?
  end
end
