class Ipbubbles::RuleBuilder
  
  def initialize(name = nil, opts = {})
    @name = name
    @opts = opts
  end

  def input(v=nil);             @opts[:input]            = v; self; end
  def icmp_type(v=nil);         @opts[:icmp_type]        = v; self; end
  def output(v=nil);            @opts[:output]           = v; self; end
  def match(v=nil);             @opts[:match]            = v; self; end
  def limit_per_second(v=nil);  @opts[:limit_per_second] = v; self; end
  def limit_per_minute(v=nil);  @opts[:limit_per_minute] = v; self; end
  def limit_per_hour(v=nil);    @opts[:limit_per_hour]   = v; self; end
  def limit_per_day(v=nil);     @opts[:limit_per_day]    = v; self; end
  def log_level(v=nil);         @opts[:log_level]        = v; self; end
  def log_prefix(v=nil);        @opts[:log_prefix]       = v; self; end
  def set_mark(v=nil);          @opts[:set_mark]         = v; self; end
  def save_mark(v=true);        @opts[:save_mark]        = v; self; end
  def accept(v=true);           @opts[:accept]           = v; self; end
  def restore_mark(v=true);     @opts[:restore_mark]     = v; self; end
  def syn(v=true);              @opts[:syn]              = v; self; end
  def tcp_flags(*args);         @opts[:tcp_flags]        = args; self; end
  def ctstate(*args);           @opts[:ctstate]          = args; self; end
  def state(*args);             @opts[:state]            = args; self; end
  def jump(v);                  @opts[:jump]             = v; self; end
  def table(v);                 @opts[:table]            = v; self; end
  def chain(v);                 @opts[:chain]            = v; self; end
  def source_port(v);           @opts[:source_port]      = v; self; end
  def destination_port(v=true); @opts[:destination_port] = v; self; end
  def destination(*args)        @opts[:destination]      = args; self; end
  def not_destination(*args)    @opts[:not_destination]  = args; self; end
  def protocol(v=nil);          @opts[:protocol]       = v; self; end
  def source(*args)             @opts[:source]           = args; self; end
  
  def build
    Ipbubbles::Rule.new(@name, @opts.clone)
  end
end