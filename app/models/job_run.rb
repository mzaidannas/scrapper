class JobRun < ApplicationRecord
  self.primary_key = :id
  enum :status, {pending: 'pending', success: 'success', error: 'error', warning: 'warning'}
  include Partitioned
end
