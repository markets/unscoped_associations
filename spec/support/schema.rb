ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.boolean :active
  end

  create_table :comments, force: true do |t|
    t.integer :user_id
    t.boolean :public
    t.timestamps
  end

  create_table :votes, force: true do |t|
    t.references :votable, polymorphic: true
    t.boolean :public
    t.timestamps
  end
end
