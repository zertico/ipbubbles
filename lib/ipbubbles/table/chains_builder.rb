class Ipbubbles::Table::ChainsBuilder
  
  def initialize (chains, opts)
    @rules = []
    @opts = opts
    @chains = chains
  end
  
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
  
  def build
    Ipbubbles::Chain.new(@inputs, @rules)
  end
end