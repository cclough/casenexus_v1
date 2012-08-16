class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|

      t.string :type
      t.integer :user_id
      t.integer :sender_id
      t.text  :content
      t.boolean :read, default: :false

      t.timestamps

    end
  end
end
