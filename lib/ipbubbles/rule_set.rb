class Ipbubbles::RuleSet

  def initialize(opts, tables)
    @opts = opts
    @tables = tables
  end

  def to_iptables
    output = ""
    @tables.each do |table|
      output = table.to_iptables
    end
    output
  end
end

# def rule(&block)
#   Docile.dsl_eval(Ipbubbles::RuleBuilder.new(), &block).build
# end