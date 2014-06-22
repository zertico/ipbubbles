class Ipbubbles::Chain::Outputs

  def initialize(outputs, rules)
    @outputs = outputs
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