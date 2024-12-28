class CreateJobRuns < ActiveRecord::Migration[7.0]
  def up
    create_enum :job_statuses, %w[pending success error warning]
    execute <<-SQL
      CREATE TABLE job_runs (
        id bigserial NOT NULL,
        name character varying(256) NOT NULL,
        status job_statuses NOT NULL DEFAULT 'pending',
        completed_at timestamp,
        created_at timestamp NOT NULL,
        updated_at timestamp NOT NULL,
        error_message character varying(256),
        error_detail text,
        primary key (name, created_at)
      ) PARTITION BY RANGE (created_at);
    SQL
  end

  def down
    drop_table :job_runs, force: :cascade
    drop_enum :job_statuses
  end
end
