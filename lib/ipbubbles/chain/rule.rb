class Ipbubbles::Chain::Rule

  def initialize(table, chain, operation)
    @table = table
    @chain = chain.to_s.upcase.gsub(/_/,"-")
    @operation = operation
  end

  def to_iptables
    operation = case @operation
    when :create; "-N"
    when :delete; "-X"
    when :flush; "-F"
    end
    "iptables -t #{@table} #{operation} #{@chain}\n"
  end
end