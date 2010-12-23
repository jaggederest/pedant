module Pedant
  class TypeError < StandardError; end
  class GuardError < StandardError; end
  
  # This is a dummy module that stands in place of the actual guarding
  # code for situations where the overhead of using runtime guards for
  # typechecking would be unacceptable. An example would be running
  # your guards in development, test, and qa environments, then
  # disabling it for production.
  
  module Dummy

    def self.included(base)
      base.extend ClassMethods
      Class.extend ClassMethods
    end

    def self.extended(base)
      base.extend ClassMethods
      Class.extend ClassMethods
    end

    module ClassMethods; def returns(*args, &block); end; def accepts(*args, &block); end; end
  end
  
  # A module used for guarding the arguments to methods. Note that
  # this only checks the types of all the arguments against the
  # permitted list - we let Ruby's built-in argument checking handle
  # the wrong number of arguments or similar problems
  
  module Accepts
    def self.included(base)
      base.extend ClassMethods
      Class.extend ClassMethods
    end

    module ClassMethods
      
      # takes a symbol for a method to override, a list of permitted
      # classes (note that superclasses of the desired class work,
      # e.g. Numeric includes Integer, Float, Rational, etc), and an
      # optional block for manual guards. These run for each argument
      # passed to the method - all arguments must be of the listed types
      
      def accepts(sym, *klasses, &block)
        old_method = instance_method(sym)
        self.send(:define_method, sym) do |*args|

          unless klasses.empty? or args.empty?
            args.each do |arg|
              unless klasses.any? {|k| arg.is_a?(k)}
                raise Pedant::TypeError, "Bad argument value! Got #{arg.inspect}, " \
                "expected instance of #{klasses.inspect}."
              end

              unless block.nil? or block.call(arg)
                raise Pedant::GuardError, "Did not pass user-defined guard."
              end
            end
          end
          old_method.bind(self).call(*args)
        end
      end
    end
  end
  
  # A module used for guarding the return value from methods. Note that
  # this only checks the types of the return value against the
  # permitted list
  
  module Returns

    def self.included(base)
      base.extend ClassMethods
      Class.extend ClassMethods
    end

    def self.extended(base)
      base.extend ClassMethods
      Class.extend ClassMethods
    end

    module ClassMethods

      # Takes a symbol for a method to override, a list of classes
      # (note that superclasses of the desired class work,
      # e.g. Numeric will allow Integer, Float, Rational, etc), and an
      # optional block for a manual guard. 
      
      def returns(sym, *klasses, &block)
        old_method = instance_method(sym)
        self.send(:define_method, sym) do |*args|
	  ret = old_method.bind(self).call(*args)
        
          # Type check
          unless klasses.empty? or klasses.any?{|klass| ret.is_a?(klass) }
            raise Pedant::TypeError, "Bad return value! Got #{ret.inspect}, " \
	      "expected instance of #{klasses.inspect}."
	  end
        
	  # User-defined guard
          unless block.nil? or block.call(ret)
            raise Pedant::GuardError, "Did not pass user-defined guard."
          end

	  ret
	end
      end
    end
  end
end
