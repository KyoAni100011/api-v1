class InitDatabase < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end

    add_index :users, :email, unique: true

    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.datetime :revoked_at
      t.string :ip_address
      t.string :user_agent
      t.timestamps
    end

    add_index :sessions, :token, unique: true

    create_table :tokens do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :token, null: false
      t.string :token_type, null: false
      t.datetime :expires_at
      t.datetime :revoked_at
      t.json :metadata
      t.timestamps
    end

    add_index :tokens, :token, unique: true
    add_index :tokens, [:user_id, :token_type]

    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.string :image_url

      t.timestamps
    end

    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end

    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end

    add_index :likes, [:user_id, :post_id], unique: true
  end
end