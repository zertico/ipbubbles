class Ipbubbles::Chain::SourcePorts

  def initialize(source_ports, rules)
    @source_ports = source_ports
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