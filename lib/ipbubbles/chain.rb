class Ipbubbles::Chain

  def initialize(opts, rules)
    @opts = opts
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