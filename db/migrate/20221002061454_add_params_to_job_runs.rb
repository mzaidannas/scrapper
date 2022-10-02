class AddParamsToJobRuns < ActiveRecord::Migration[7.0]
  def change
    add_column :job_runs, :params, :jsonb, null: false, default: '{}'
    add_index :job_runs, :params, using: :gin
  end
end
