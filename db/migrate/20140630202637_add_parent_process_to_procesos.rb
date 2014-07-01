class AddParentProcessToProcesos < ActiveRecord::Migration
  def change
  	add_column :procesos, :pprocess_id, :int
  end
end
