class Ipbubbles::RuleSetBuilder
  
  def initialize(opts = {})
    @tables = []
    @opts = {}
  end

  # def input(v=nil);         @opts[:input]       = v; self; end
  # def output(v=nil);        @opts[:output]      = v; self; end
  # def match(v=nil);         @opts[:match]       = v; self; end
  # def log_level(v=nil);     @opts[:log_level]   = v; self; end
  # def log_prefix(v=nil);    @opts[:log_prefix]  = v; self; end
  # def set_mark(v=nil);      @opts[:set_mark]    = v; self; end
  # def save_mark(v=true);    @opts[:save_mark]   = v; self; end
  # def ctstate(*args);       @opts[:ctstate]     = args; self; end
  # def jump(v);              @opts[:jump]        = v; self; end
  # def table(v);             @opts[:table]       = v; self; end
  # def chain(v);            @opts[:chain]       = v; self; end
  
  def table(name = :filter, &block)
    created_table = Docile.dsl_eval(Ipbubbles::TableBuilder.new(name, @opts.clone), &block).build
    @tables << created_table
    created_table
  end
  
  def build
    Ipbubbles::RuleSet.new(@opts, @tables)
  end
end