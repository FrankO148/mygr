class CreateProcesos < ActiveRecord::Migration
  def change
    create_table :procesos do |t|
      t.string :user
      t.string :pid
      t.string :p_cpu
      t.string :p_mem
      t.string :vsz
      t.string :tty
      t.string :stat
      t.string :start
      t.string :time
      t.string :command

      t.timestamps
    end
  end
end
