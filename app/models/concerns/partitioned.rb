module Partitioned
  extend ActiveSupport::Concern

  included do
    class_attribute :partition_column, instance_writer: false, default: 'created_at'
    class_attribute :partition_freq, instance_writer: false, default: 'month'
    range_partition_by { "DATE_TRUNC('#{partition_freq}', #{partition_column})" }
    before_validation :check_or_create_partition
  end

  class_methods do
    def set_partition(p_column:, p_freq:)
      self.partition_column = p_column
      self.partition_column = p_freq
    end

    def maintenance
      partitions = [Time.zone.today.public_send("prev_#{partition_freq}"), Time.zone.today, Time.zone.today.public_send("next_#{partition_freq}")]

      partitions.each do |day|
        partition_name = partition_name_for(day)
        next if ActiveRecord::Base.connection.table_exists?(partition_name)
        create_partition(
          name: partition_name,
          start_range: day.public_send("beginning_of_#{partition_freq}"),
          end_range: day.public_send("next_#{partition_freq}").public_send("beginning_of_#{partition_freq}")
        )
      end

      # unless Rails.env.development?
      #   ActiveRecord::Base.connection.execute <<-SQL.squish
      #     CALL alter_old_partitions_set_access_method(
      #       '#{table_name}',
      #       date_trunc('#{partition_freq}', now() - interval '1 #{partition_freq}') /* older_than */,
      #       'columnar'
      #     );
      #   SQL
      # end
    end

    def partition_name_for(day)
      # Don't change original table_name reference for active_record
      partition_name = table_name.dup
      {year: 'y', month: 'm', day: 'd'}.each do |key, val|
        partition_name.concat("_#{val}#{day.public_send(key)}")
        break if key.to_s == partition_freq
      end
      partition_name
    end
  end

  def check_or_create_partition
    today = Time.zone.today
    partition_name = self.class.partition_name_for(today)
    return if ActiveRecord::Base.connection.table_exists?(partition_name)

    self.class.create_partition(
      name: partition_name,
      start_range: today.public_send("beginning_of_#{partition_freq}"),
      end_range: today.public_send("next_#{partition_freq}").public_send("beginning_of_#{partition_freq}")
    )
    # unless Rails.env.development?
    #   ActiveRecord::Base.connection.execute <<-SQL.squish
    #     CALL alter_old_partitions_set_access_method(
    #       '#{table_name}',
    #       date_trunc('#{partition_freq}', now() - interval '1 #{partition_freq}') /* older_than */,
    #       'columnar'
    #     );
    #   SQL
    # end
  end
end
