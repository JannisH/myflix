class CreateQueueables < ActiveRecord::Migration
  def change
    create_table :queueables do |t|
      t.integer :video_queue_id
      t.integer :video_id
      t.integer :priority
      t.timestamps
    end
  end
end
