class Ipbubbles::Table::ElementBuilder
  
  def initialize (elements, kind, opts)
    @chains = []
    @opts = opts
    @elements = elements
    @kind = kind
  end
  
  def chain(name = :input, &block)
    @elements.each do |input|
      chain_opts = @opts.clone
      chain_opts[@kind.to_sym] = input
      created_chain = Docile.dsl_eval(Ipbubbles::ChainBuilder.new(name, chain_opts), &block).build
      @chains << created_chain
      created_chain
    end
    @chains
  end
  
  def build
    Ipbubbles::Chain.new(@elements, @chains)
  end
end