class Ipbubbles::Table::OutputsBuilder
  
  def initialize (outputs, opts)
    @chains = []
    @opts = opts
    @outputs = outputs
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

  # def outputs(outputs, &block);
  #   @outputs = outputs
  # end
  #
  # def addresses(addresses, &block);
  #   @addresses = addresses
  # end
  #
  # def ports(ports, &block);
  #   @ports = ports
  # end
  
  def chain(name = :input, &block)
    @outputs.each do |output|
      chain_opts = @opts.clone
      chain_opts[:output] = output
      created_chain = Docile.dsl_eval(Ipbubbles::ChainBuilder.new(name, chain_opts), &block).build
      @chains << created_chain
      created_chain
    end
    @chains
  end
  
  def build
    Ipbubbles::Table::Outputs.new(@outputs, @chains)
  end
end