require 'thread'
require 'logger'

module LQ
	
	def self.start_up()
		
		@queue ||= Array.new()
		@mutex = Mutex.new()
		@shutdown = false
		@log = Logger.new(STDOUT) # TODO Make this settable
		
		@thread = Thread.new do
			
			get_to_da_choppa
			
		end
		
	end
	
	def self.get_to_da_choppa()
		
		while (!@shutdown)
			
			if (@queue.length > 0)
				
				val = ""
				
				@mutex.synchronize do
					val = @queue.shift()
				end
				
				@log.add(val[0],val[1])
				
			end
			
			sleep(0.1)
		
		end
			
		
	end
	
	def self.shutdown()
		
		#Shutting down will disallow anymore additions
		#to the queue, let the queue finish, then stop.
		@shutdown = true
		@thread.join
		
	end
	
	def self.add(severity, msg=nil)
		
		if (@shutdown)
			return
		end
		
		@mutex.synchronize do
			
			@queue.push([severity, msg])
			
		end
		
	end
	
	def self.debug(msg=nil)
		add(Logger::Severity::DEBUG, msg)
	end
	
	def self.info(msg=nil)
		add(Logger::Severity::INFO, msg)
	end
	
	def self.warn(msg=nil)
		add(Logger::Severity::WARN, msg)
	end
	
	def self.error(msg=nil)
		add(Logger::Severity::ERROR, msg)
	end
	
	def self.fatal(msg=nil)
		add(Logger::Severity::FATAL, msg)
	end
	
	def self.unknown(msg=nil)
		add(Logger::Severity::UNKNOWN, msg)
	end
	
end