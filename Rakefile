ENV["RACK_ENV"] ||= "development"

namespace :db do

  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel"
    require "yaml"

    Sequel.extension :migration

    db = YAML.load_file("config/database.yml")
    db = Sequel.connect(db[ENV["RACK_ENV"]])

    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end
end
