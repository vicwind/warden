#http://rcrowley.org/articles/clint.html
#https://github.com/rcrowley/clint
# ##Clint is an alternative Ruby command line argument parser that's very good for programs using the subcommand pattern familiar from git(1), svn(1), apt-get(8), and many others. In addition, it separates option declarations from usage and help messages becuase the author feels like that's a better idea.

# Clint options are declared by passing hash arguments to Clint#options. The hash keys should be Symbols. If the value is also a Symbol, an alias is defined from the key to the value. If the value is a Class, Clint attempts to find a default value for that class. Otherwise, the value is treated as the default and the value's class will be used to construct type-accurate values from command line arguments.

# Clint#options may be called repeatedly to declare extra options and aliases. Clint#reset can be used at any time to clear all declared options and aliases.

# Clint#parse may likewise be called repeatedly. At the end of each invocation, it stores the remaining non-option arguments, meaning that arguments (for example, ARGV) must only be passed as a parameter to the first invocation.

# Clint#dispatch may be called after Clint#parse with a callable that will receive the arguments and options. If there is a mismatch in the arity of the callable's #call method, the callable's constructor is called with no arguments and the resulting object is treated as the callable that receives the arguments and options.

# Clint#subcommand may be called after Clint#parse to automatically handle the subcommand pattern as follows. The first non-option argument is taken to be the subcommand, which must exist as a singleton or instance method of the class object passed to Clint#subcommand. If a suitable class method is found, it is called with all remaining arguments, including a hash of the parsed options if we can get away with it. Otherwise, an instance is constructed with the next non-option argument and the instance method is called with all remaining arguments, again including a hash of the parsed options if we can get away with it.

# Due to limitations in the Ruby 1.8 grammar, all methods that could act as subcommands must not declare default argument values except options={} if desired.

class Clint

  def initialize(options={})
    reset
    @strict = !!options[:strict]
  end

  def usage
    if block_given?
      @usage = Proc.new
    else
      @usage.call if @usage.respond_to? :call
    end
  end

  def help
    if block_given?
      @help = Proc.new
    else
      usage
      @help.call if @help.respond_to? :call
    end
  end

  # Reset the list of valid options and aliases.
  def reset
    @options, @aliases = {}, {}
  end

  # Add new valid options and aliases with either classes to be constructed
  # or default values (from which classes are inferred).  This returns
  # @options and thus works as an attr_reader with no arguments.
  def options(options={})
    options.each do |option, default|
      option = option.to_sym
      if Symbol == default.class
        @aliases[option] = default
      else
        if Class == default.class
          if default.respond_to? :new
            begin
              @options[option] = default.new
            rescue ArgumentError
              @options[option] = default.new(nil)
            end
          else
            begin
              @options[option] = default()
            rescue ArgumentError
              @options[option] = default(nil)
            end
          end
        else
          @options[option] = default
        end
      end
    end
    @options
  end

  attr_reader :aliases

  # Parse arguments, saving options in @options and leaving everything else
  # in @args.
  def parse(args=nil)
    args = @args if args.nil?
    i = 0
    while args.length > i do

      # Skip anything not structured like an option.
      option, value = case args[i]
      when /^-([^-=\s]+)$/
        args.delete_at i
        $1.reverse.each_char { |c| args.insert i, "-#{c}" }
        [$1[0, 1].to_sym, nil]
      when /^-([^-=\s])\s*(.+)$/
        [$1.to_sym, $2]
      when /^--([^=\s]+)$/
        [$1.to_sym, nil]
      when /^--([^=\s]+)(?:=|\s+)(.+)?$/
        [$1.to_sym, $2]
      else
        i += 1
        next
      end

      # Follow aliases through to a real option.
      option = @aliases[option] while @aliases[option]

      # Skip unknown options unless we're in strict mode.
      if @options[option].nil?
        if @strict
          usage
          exit 1
        end
        i += 1
        next
      end

      # Handle boolean options.
      if [TrueClass, FalseClass].include? @options[option].class
        unless value.nil?
          usage
          exit 1
        end
        args.delete_at i
        @options[option] = !@options[option]

      # Handle options with values.  The call to new below may raise
      # NoMethodError but this is allowed to surface so it's noticed
      # during development.
      else
        args.delete_at i
        value = args.delete_at(i) if value.nil?
        if value.nil?
          usage
          exit 1
        end
        @options[option] = @options[option].class.new(value)

      end
    end
    @args = args
  end

  # Pass options and arguments however possible to the given callable, which
  # could be a Proc or just an object that responds to the method call.
  def dispatch(callable)
    arity = begin
      callable.arity
    rescue NoMethodError
      callable.method(:call).arity
    end
    if @args.length == arity
      callable.call(*@args)
    elsif -@args.length - 1 == arity
      callable.call(*(@args + [@options]))
    else
      dispatch callable.new
      exit 0
    end
  rescue Exception => e
    raise e if SystemExit == e.class || SignalException == e.class
    usage
    exit 1
  end

  # Treat the first non-option argument as a subcommand in the given class.
  # If a suitable class method is found, it is called with all remaining
  # arguments, including @options if we can get away with it.  Otherwise,
  # an instance is constructed with the next non-option argument and the
  # subcommand is sent to the instance with the remaining non-option
  # arguments.
  def subcommand(klass)

    # Find the subcommand.
    if 1 > @args.length
      usage
      exit 1
    end
    subcommand = @args.shift.to_sym

    # Give the caller the opportunity to declare more options.
    yield subcommand if block_given?

    # Execute the subcommand as a class method.
    if klass.singleton_methods(false).include? subcommand
      arity = klass.method(subcommand).arity
      if @args.length == arity || -@args.length - 1 == arity
        begin
          klass.send subcommand, *(@args + [@options])
        rescue ArgumentError
          klass.send subcommand, *@args
        end
        exit 0
      end
    end

    # Execute the subcommand as an instance method.
    arity = klass.allocate.method(:initialize).arity
    if 0 > arity
      arity = arity.abs - 1
    end
    if arity > @args.length
      usage
      exit 1
    end
    instance = klass.new(*@args.slice!(0, arity))
    if instance.public_methods(false).any? {|m| m == subcommand || m == subcommand }
      arity = instance.method(subcommand).arity
      if @args.length != arity && -@args.length - 1 != arity
        usage
        exit 1
      end
      begin
        instance.send subcommand, *(@args + [@options])
      rescue ArgumentError
        instance.send subcommand, *@args
      end
      exit 0
    end

    # No suitable class or instance method was found.
    usage
    exit 1

  end

end

