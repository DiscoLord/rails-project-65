class MakeStateNonNull < ActiveRecord::Migration[7.2]
  def change
    change_column_default :bulletins, :state, 'draft'
    change_column_null :bulletins, :state, false
  end
end
