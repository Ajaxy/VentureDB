class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :type_id
      t.string :name
      t.string :phone
      t.text :text

      t.timestamps
    end
  end
end
