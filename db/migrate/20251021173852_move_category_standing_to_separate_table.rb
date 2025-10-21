class MoveCategoryStandingToSeparateTable < ActiveRecord::Migration[8.0]
  def up
    create_table :category_standings do |t|
      t.references :player, null: false, foreign_key: true, index: { unique: true }

      # Normal
      t.bigint  :normal_score
      t.integer :normal_rank, index: true
      t.integer :previous_normal_rank

      # Racing
      t.bigint  :racing_score
      t.integer :racing_rank, index: true
      t.integer :previous_racing_rank

      # Survivor
      t.bigint  :survivor_score
      t.integer :survivor_rank, index: true
      t.integer :previous_survivor_rank

      # Defilante
      t.bigint  :defilante_score
      t.integer :defilante_rank, index: true
      t.integer :previous_defilante_rank

      t.timestamps
    end

    execute <<~SQL
      INSERT INTO category_standings (
        player_id,
        normal_score, normal_rank, previous_normal_rank,
        racing_score, racing_rank, previous_racing_rank,
        survivor_score, survivor_rank, previous_survivor_rank,
        defilante_score, defilante_rank, previous_defilante_rank,
        created_at, updated_at
      )
      SELECT
        id,
        normal_score, normal_rank, previous_normal_rank,
        racing_score, racing_rank, previous_racing_rank,
        survivor_score, survivor_rank, previous_survivor_rank,
        defilante_score, defilante_rank, previous_defilante_rank,
        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM players
    SQL

    remove_column :players, :normal_score, :bigint
    remove_column :players, :normal_rank, :integer
    remove_column :players, :previous_normal_rank, :integer

    remove_column :players, :survivor_score, :bigint
    remove_column :players, :survivor_rank, :integer
    remove_column :players, :previous_survivor_rank, :integer

    remove_column :players, :racing_score, :bigint
    remove_column :players, :racing_rank, :integer
    remove_column :players, :previous_racing_rank, :integer

    remove_column :players, :defilante_score, :bigint
    remove_column :players, :defilante_rank, :integer
    remove_column :players, :previous_defilante_rank, :integer
  end

  def down
    add_column :players, :normal_score, :bigint
    add_column :players, :normal_rank, :integer
    add_column :players, :previous_normal_rank, :integer

    add_column :players, :racing_score, :bigint
    add_column :players, :racing_rank, :integer
    add_column :players, :previous_racing_rank, :integer

    add_column :players, :survivor_score, :bigint
    add_column :players, :survivor_rank, :integer
    add_column :players, :previous_survivor_rank, :integer

    add_column :players, :defilante_score, :bigint
    add_column :players, :defilante_rank, :integer
    add_column :players, :previous_defilante_rank, :integer

    execute <<~SQL
      UPDATE players p
      SET
        normal_score = cs.normal_score,
        normal_rank = cs.normal_rank,
        previous_normal_rank = cs.previous_normal_rank,
        survivor_score = cs.survivor_score,
        survivor_rank = cs.survivor_rank,
        previous_survivor_rank = cs.previous_survivor_rank,
        racing_score = cs.racing_score,
        racing_rank = cs.racing_rank,
        previous_racing_rank = cs.previous_racing_rank,
        defilante_score = cs.defilante_score,
        defilante_rank = cs.defilante_rank,
        previous_defilante_rank = cs.previous_defilante_rank
      FROM category_standings cs
      WHERE cs.player_id = p.id
    SQL

    drop_table :category_standings
  end
end
