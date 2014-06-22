class Ipbubbles::Chain::ElementBuilder
  
  def initialize (elements, kind, opts)
    @rules = []
    @opts = opts
    @kind = kind
    @elements = elements
  end
  
  def rule(name = nil, &block)
    @elements.each do |element|
      rule_opts = @opts.clone
      rule_opts[@kind.to_sym] = element
      created_rule = Docile.dsl_eval(Ipbubbles::RuleBuilder.new(name, rule_opts), &block).build
      @rules << created_rule
      created_rule
    end
    @rules
  end
  
  def build
    Ipbubbles::Chain.new(@opts, @rules)
  end
end