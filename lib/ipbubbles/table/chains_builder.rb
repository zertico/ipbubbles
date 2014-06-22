class Ipbubbles::Table::ChainsBuilder
  
  def initialize (chains, opts)
    @rules = []
    @opts = opts
    @chains = chains
  end

  # def input(v=nil);           @opts[:input]            = v; self; end
  # def match(v=nil);           @opts[:match]            = v; self; end
  # def protocol(v=nil);        @opts[:protocol]         = v; self; end
  # def icmp_type(v=nil);       @opts[:icmp_type]        = v; self; end
  # def syn(v=true);            @opts[:syn]              = v; self; end
  # def destination(*args)      @opts[:destination]      = args; self; end
  # def destination_port(v);    @opts[:destination_port] = v; self; end
  # def source(*args)           @opts[:source]           = args; self; end
  # def source_ports(*args);    @opts[:source_ports]     = args; self; end

  # def accept(v=true);           @opts[:accept]           = v; self; end
  
  # def inputs(inputs, &block);
  #   @inputs = inputs
  # end
  #
  # def addresses(addresses, &block);
  #   @addresses = addresses
  # end
  #
  # def ports(ports, &block);
  #   @ports = ports
  # end
  
  def rule(name = nil, &block)
    @chains.each do |chain|
      rule_opts = @opts.clone
      rule_opts[:chain] = chain
      created_rule = Docile.dsl_eval(Ipbubbles::RuleBuilder.new(name, rule_opts), &block).build
      @rules << created_rule
      created_rule
    end
    @rules
  end
  
  # def chain(name = :input, &block)
  #   @inputs.each do |input|
  #     chain_opts = @opts.clone
  #     chain_opts[:input] = input
  #     created_chain = Docile.dsl_eval(Ipbubbles::ChainBuilder.new(name, chain_opts), &block).build
  #     @chains << created_chain
  #     created_chain
  #   end
  #   @chains
  # end
  
  def build
    Ipbubbles::Chain.new(@inputs, @rules)
  end
end