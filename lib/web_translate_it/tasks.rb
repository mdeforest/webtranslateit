# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'web_translate_it')

namespace :trans do  
  desc "Fetch translation files from Web Translate It"
  task :fetch, :locale do |task, args|
    welcome_message
    puts "Fetching file for locale #{args.locale}…"
    configuration = WebTranslateIt::Configuration.new
    configuration.files.find_all{ |file| file.locale == locale }.each do |file|
      response_code = file.fetch
      handle_response(file.file_path, response_code)
    end
  end
  
  namespace :fetch do
    desc "Fetch all the translation files from Web Translate It"
    task :all do
      welcome_message
      configuration = WebTranslateIt::Configuration.new
      locales = configuration.target_locales
      configuration.ignore_locales.each{ |locale_to_ignore| locales.delete(locale_to_ignore) }
      puts "Fetching all files for all locales…"
      locales.each do |locale|
        configuration.files.find_all{ |file| file.locale == locale }.each do |file|
          Dir.mkdir(file.file_path) unless File.exist?(file.file_path)
          response_code = file.fetch(locale) 
          handle_response(file.file_path, response_code)
        end
      end
    end
  end
  
  desc "Upload the translation files for a locale to Web Translate It"
  task :upload, :locale do |task, args|
    welcome_message
    puts "Uploading file for locale #{args.locale}…"
    configuration = WebTranslateIt::Configuration.new
    configuration.files.find_all{ |file| file.locale == args.locale }.each do |file|
      response_code = file.upload(args.locale)
      handle_response(file.file_path, response_code)
    end
  end
    
  def handle_response(file_path, response_code)
    if response_code < 400
      puts "#{file_path}: #{response_code}, OK"
    else
      puts "#{file_path}: #{response_code}, Problem!"
    end
  end
  
  def welcome_message
    puts "Web Translate It v#{WebTranslateIt::Util.version}"
  end
end