class CreateSpeeches < ActiveRecord::Migration
  def change
    create_table :speeches do |t|
      t.string :date
      t.string :text
      t.references :candidate, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
