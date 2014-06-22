class Ipbubbles::Table

  def initialize(name, chains)
    @name = name
    @chains = chains
  end

  def to_iptables
    output = ""
    @chains.each do |chain|
      output << chain.to_iptables
    end
    output
  end
end