# frozen_string_literal: true

class AddAdminToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :admin, :boolean, default: true, null: false
  end
end
