#lib/tasks/import.rake
require 'csv'
desc "Imports a CSV file into an ActiveRecord table"
task :import_downloads => :environment do
  Dir.glob('config/seed_data/downloads/*.csv') do |csv_file|
    CSV.foreach(csv_file, :headers => true) do |row|
      begin
        p "Adding code #{row.to_hash}"
        Download.create!(row.to_hash)
      rescue Exception => e
        p e
      end
    end
  end
end
