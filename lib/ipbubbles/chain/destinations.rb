class Ipbubbles::Chain::Destinations

  def initialize(destionations, rules)
    @destionations = destionations
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