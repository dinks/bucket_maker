class CreateBuckets < ActiveRecord::Migration
  def change
    #
    create_table :buckets do |t|
      t.string      :series_key
      t.string      :group_name
      t.references  :bucketable, polymorphic: true
      t.timestamps
    end
    add_index :buckets, :series_key
  end
end
