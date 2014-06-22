class Ipbubbles::Table::Inputs

  def initialize(inputs, rules)
    @inputs = inputs
    @rules = rules
  end

  def to_iptables
    output = ""
    @rules.each do |rule|
      output << rule.to_iptables
    end
    output
  end

end