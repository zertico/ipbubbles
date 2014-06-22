class Ipbubbles::Types
  
  @@data = {}
  @@data[:all] = [:accept, :drop, :log, :netmap, :queue, :return, :same, :tcpmss, :ulog]
  @@data[:filter] = {}
  @@data[:filter][:input] = [:mirror, :reject]
  @@data[:filter][:output] = [:mirror, :reject]
  @@data[:filter][:forward] = [:mirror, :reject]
  
  @@data[:nat] = {}
  @@data[:nat][:prerouting] = [:dnat, :mirror, :redirect]
  @@data[:nat][:postrouting] = [:masquerade, :snat]
  @@data[:nat][:output] = [:dnat, :redirect, :reject]
  
  @@data[:mangle] = {}
  @@data[:mangle][:all] = [:mark, :tos, :ttl]
  @@data[:mangle][:prerouting] = [:mirror]
  @@data[:mangle][:output] = [:reject]
  @@data[:mangle][:forward] = [:dscp, :ecn, :mirror, :reject]
  @@data[:mangle][:input] = [:mirror, :reject]
  @@data[:mangle][:postrouting] = [:classify]
  
  @@data[:raw] = {}
  @@data[:raw][:prerouting] = [:mirror]
  @@data[:raw][:output] = [:reject]
  
  def self.has_table? table
    @@data.has_key?(table)
  end
  
  def self.has_chain? table, chain
    @@data[table].has_key?(chain)
  end
  
  def self.add_chain table, chain
    return nil unless @@data.has_key? table
    @@data[table][chain] = []
    true
  end
  
  def self.remove_chain table, chain
    return nil unless @@data.has_key? table
    return nil unless @@data[table].has_key? chain
    @@data[table].delete chain
    true
  end
  
  def self.valid_target? target
    @@data[:all].include?(target)
  end
  
  def self.valid_target_for_table? table, target
    return true if valid_target? target
    @@data[table][:all].include?(target) if @@data[table].has_key?(:all)
  end
  
  def self.valid_target_for_chain? table, chain, target
    return true if valid_target? target
    return true if valid_target_for_table? table, target
    @@data[table][chain].include?(target) if @@data[table].has_key?(chain)
  end
end