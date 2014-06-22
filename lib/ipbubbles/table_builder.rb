class Ipbubbles::TableBuilder
  
  def initialize(name = :filter, opts = {})
    raise Exception unless Ipbubbles::Types.has_table? name
    @name = name
    @chains = []
    @opts = {}
    @opts[:table] = name
  end
  
  %w(input output).each do |method|
    define_method((method+"s").to_sym) do |elements, &block|
      @chains << Docile.dsl_eval(Ipbubbles::Table::ElementBuilder.new(elements, method, @opts.clone), &block).build
    end
  end
  
  def chains(elements, &block);
    elements.each do |chain|
      @chains << Docile.dsl_eval(Ipbubbles::ChainBuilder.new(chain, @opts.clone), &block).build
    end
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