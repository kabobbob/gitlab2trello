db = YAML.load_file("config/database.yml")
DB = Sequel.connect(db[ENv['RACK_ENV']])

class User < Sequel::Model
  set_dataset DB[:users]
end
