class CreateTestRunHistories < ActiveRecord::Migration
  def change
    create_table :test_run_histories do |t|
      t.with_options(:null => false) do |tt|
        t.integer :run_sequence, :default => 0
        t.boolean :is_last_run
      end

      t.timestamps
    end
  end
end
