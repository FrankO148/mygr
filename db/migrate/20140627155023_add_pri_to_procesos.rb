class AddPriToProcesos < ActiveRecord::Migration
  def change
  	add_column :procesos, :pri, :string
  end
end
