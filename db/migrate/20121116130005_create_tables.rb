class CreateTables < ActiveRecord::Migration
  def change
    create_table :markers do |t|
      t.string :email
      t.string :location
      t.float :latitude
      t.float :longitude
      t.string :referrer_code
      t.boolean :is_subscriber
      t.integer :num_referred, :default => 0

      t.timestamps
    end

    create_table :downloads do |t|
      t.integer :marker_id
      t.string :code
      t.string :reference
      t.boolean :used

      t.timestamps
    end

  end
end
