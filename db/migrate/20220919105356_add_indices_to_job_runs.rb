class AddIndicesToJobRuns < ActiveRecord::Migration[7.0]
  def change
    add_index :job_runs, :id
    add_index :job_runs, :name, using: :hash, name: :index_job_runs_on_name_hash
    add_index :job_runs, :completed_at
    add_index :job_runs, :created_at
    add_index :job_runs, :name, using: :gin, opclass: :gin_trgm_ops, name: :index_job_runs_on_name_gin
  end
end
