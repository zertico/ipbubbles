class Ipbubbles::RuleSetBuilder
  
  def initialize(opts = {})
    @tables = []
    @opts = {}
  end
  
  def table(name = :filter, &block)
    created_table = Docile.dsl_eval(Ipbubbles::TableBuilder.new(name, @opts.clone), &block).build
    @tables << created_table
    created_table
  end
  
  def build
    Ipbubbles::RuleSet.new(@opts, @tables)
  end
end