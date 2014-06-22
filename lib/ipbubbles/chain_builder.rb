class Ipbubbles::ChainBuilder
  
  def initialize (name, opts)
    @rules = []
    @opts = opts
    @opts[:table] = opts[:table]
    @opts[:chain] = name
    unless Ipbubbles::Types.has_chain? opts[:table], opts[:chain]
      @rules << Ipbubbles::Chain::Rule.new(opts[:table], opts[:chain], :create)
      Ipbubbles::Types.add_chain opts[:table], opts[:chain]
    end
  end

  def input(v=nil);           @opts[:input]            = v; self; end
  def match(v=nil);           @opts[:match]            = v; self; end
  def protocol(v=nil);        @opts[:protocol]         = v; self; end
  def icmp_type(v=nil);       @opts[:icmp_type]        = v; self; end
  def syn(v=true);            @opts[:syn]              = v; self; end
  def destination(*args)      @opts[:destination]      = args; self; end
  def destination_port(v);    @opts[:destination_port] = v; self; end
  def source(*args)           @opts[:source]           = args; self; end

  %w(destination input output source_port).each do |method|
    define_method((method+"s").to_sym) do |elements, &block|
      @rules << Docile.dsl_eval(Ipbubbles::Chain::ElementBuilder.new(elements, method, @opts.clone), &block).build
    end
  end
  
  def rule(name = nil, &block)
    rule_opts = @opts.clone
    created_rule = Docile.dsl_eval(Ipbubbles::RuleBuilder.new(name, rule_opts), &block).build
    @rules << created_rule
    created_rule
  end
  
  def build
    Ipbubbles::Chain.new(@opts, @rules)
  end
end