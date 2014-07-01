class AddTreeToProcesos < ActiveRecord::Migration
  def change
  	add_column :procesos, :tree, :string
  end
end
