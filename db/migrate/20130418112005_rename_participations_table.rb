class RenameParticipationsTable < ActiveRecord::Migration
  def change
    rename_table :participations, :feedbacks
  end
end
