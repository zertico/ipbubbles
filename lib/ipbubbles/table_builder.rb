class Ipbubbles::TableBuilder
  
  def initialize(name = :filter, opts = {})
    raise Exception unless Ipbubbles::Types.has_table? name
    @name = name
    @chains = []
    @opts = {}
    @opts[:table] = name
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
  
  def inputs(inputs, &block);
    @chains << Docile.dsl_eval(Ipbubbles::Table::InputsBuilder.new(inputs, @opts.clone), &block).build
  end
  
  def chains(chains, &block);
    @chains << Docile.dsl_eval(Ipbubbles::Table::ChainsBuilder.new(chains, @opts.clone), &block).build
  end
  
  def outputs(outputs, &block);
    @chains << Docile.dsl_eval(Ipbubbles::Table::OutputsBuilder.new(outputs, @opts.clone), &block).build
  end
  
  def chain(name = :input, &block)
    chain_opts = @opts.clone
    created_chain = Docile.dsl_eval(Ipbubbles::ChainBuilder.new(name, chain_opts), &block).build
    @chains << created_chain
    created_chain
  end
  
  def build
    Ipbubbles::Table.new(@opts, @chains)
  end
end