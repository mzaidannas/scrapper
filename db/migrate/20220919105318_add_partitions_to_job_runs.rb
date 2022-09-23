class AddPartitionsToJobRuns < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    JobRun.maintenance
  end
end
