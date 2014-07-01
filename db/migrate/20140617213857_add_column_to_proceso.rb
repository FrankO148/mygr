class AddColumnToProceso < ActiveRecord::Migration
  def change
    add_column :procesos, :rss, :string
  end
end
