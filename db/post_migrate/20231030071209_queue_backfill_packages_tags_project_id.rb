# frozen_string_literal: true

class QueueBackfillPackagesTagsProjectId < Gitlab::Database::Migration[2.2]
  milestone '16.6'
  disable_ddl_transaction!
  restrict_gitlab_migration gitlab_schema: :gitlab_main

  MIGRATION = "BackfillPackagesTagsProjectId"
  DELAY_INTERVAL = 2.minutes
  BATCH_SIZE = 1000
  SUB_BATCH_SIZE = 100

  def up
    queue_batched_background_migration(
      MIGRATION,
      :packages_tags,
      :id,
      job_interval: DELAY_INTERVAL,
      queued_migration_version: '20231030071209',
      batch_size: BATCH_SIZE,
      sub_batch_size: SUB_BATCH_SIZE
    )
  end

  def down
    delete_batched_background_migration(MIGRATION, :packages_tags, :id, [])
  end
end
