class Proceso < ActiveRecord::Base
	has_one :pprocess, class_name: 'Proceso', foreign_key: 'pprocess_id'
	
	

	def self.create_pr(command)
		begin		
			pid= Process.spawn("#{command}")
			Process.detach(pid)
			if Proceso.find(pid.to_s)
				created_process=Proceso.find(pid.to_s)
			else
				created_process=Proceso.new({pid: pid.to_s})
			end	
			return created_process
		rescue  Exception => e
			created_process=Proceso.new()
			created_process.errors.add(:System, e.message)	
			return created_process
		end
	end

	def self.createAllPr
		arr_procesos=[]
		raw_data = ` ps xao user,pid,%cpu,%mem,vsz,rss,stat,tty,start,time,ni,ppid,command --width 1000 --no-headers`.split("\n")
		raw_data.each do |line_data|
			pr_data=line_data.split(" ")
			if pr_data[8].length == 8
				arr_procesos << Proceso.new({user: pr_data[0],
									pid: pr_data[1],
									p_cpu: pr_data[2],
									p_mem: pr_data[3],
									vsz: pr_data[4],
									rss: pr_data[5],
									stat: pr_data[6],
									tty: pr_data[7],
									start: pr_data[8],
									time: pr_data[9],
									pri: pr_data[10],
									command: pr_data[12],
									pprocess: arr_procesos.select{|process| process.pid==pr_data[11]}.last})
				current_process=arr_procesos.select{|process| process.pid==pr_data[1]}.last
				current_process.tree= Proceso.generate_tree(pr_data[1],arr_procesos)
			else
				arr_procesos << Proceso.new({user: pr_data[0],
									pid: pr_data[1],
									p_cpu: pr_data[2],
									p_mem: pr_data[3],
									vsz: pr_data[4],
									rss: pr_data[5],
									stat: pr_data[6],
									tty: pr_data[7],
									start: pr_data[8]+" "+pr_data[9] ,
									time: pr_data[10],
									pri: pr_data[11],
									command: pr_data[13],
									pprocess: arr_procesos.select{|process| process.pid==pr_data[12]}.last})
				current_process=arr_procesos.select{|process| process.pid==pr_data[1]}.last
				current_process.tree= Proceso.generate_tree(pr_data[1],arr_procesos)
			end				
		end

		return arr_procesos	
	end

	def self.find(pid)
		arr=Proceso.createAllPr.select {|process| process.pid==pid}
		arr.last
	end

	def self.find_by_priority(priority)
		processes=Proceso.createAllPr.select {|process| process.pri==priority}
	end

	def self.kill(pid)
		system("sudo kill -9 #{pid}")
	end	

	def self.prioritize(pid,priority)
		if system("sudo renice #{priority} #{pid}")
			return Proceso.find(pid)
		else
			return false
		end
	end

	def self.Pr_To_Hash(proceso)
		pr={user: proceso.user, 
       		pid: proceso.pid,
       		p_cpu: proceso.p_cpu,
       		p_mem: proceso.p_mem,
       		vsz: proceso.vsz,
       		rss: proceso.rss,
       		tty: proceso.tty,
       		stat: proceso.stat,
       		ni:proceso.pri,
       		start: proceso.start,
       		time: proceso.time,
       		command: proceso.tree}
	end

	def self.AllPr_To_Hash(processes)
		processes.map do |proceso|
  			{user: proceso.user, 
       		pid: proceso.pid,
       		p_cpu: proceso.p_cpu,
       		p_mem: proceso.p_mem,
       		vsz: proceso.vsz,
       		rss: proceso.rss,
       		tty: proceso.tty,
       		stat: proceso.stat,
       		ni:proceso.pri,
       		start: proceso.start,
       		time: proceso.time,
       		command: proceso.tree}
    	end
	end

	def self.search_array_tree(pid,prid_arr,processes)
		a= processes.select {|process| process.pid==pid}.last
		if a
			if a.pprocess
				prid_arr << a.pprocess.pid
				search_array_tree(a.pprocess.pid,prid_arr,processes)
			else
				return prid_arr
 			end
 		else
 			return nil	
 		end		
	end

	def self.generate_tree(pid,processes)
		prpid_arr=Proceso.search_array_tree(pid,pr=[pid],processes)
		if prpid_arr
			tree=""
			prpid_arr.reverse_each do |pid|
				if pid==prpid_arr.first
					tree= tree+ "#{processes.select {|process| process.pid==pid}.last.command}"
				else
					tree= tree+ "#{processes.select {|process| process.pid==pid}.last.command}__"
				end
			end	
			return tree
		else
			return nil
		end	
	end
	def getChildren
		processes= Proceso.createAllPr
		children= processes.select do |process|
			if process.pprocess
			process.pprocess.pid==self.pid 
			end
		end		
	end



end
