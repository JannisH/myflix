class CreateVideoQueues < ActiveRecord::Migration
  def change
    create_table :video_queues do |t|
      t.integer :user_id
      t.timestamps
    end
  end
end
