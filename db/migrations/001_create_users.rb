Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      Integer :gitlabid
      String :name
      String :email
    end
  end

  down do
    drop_table :users
  end
end
