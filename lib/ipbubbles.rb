module Ipbubbles
end

def ipbubbles(&block)
  Docile.dsl_eval(Ipbubbles::RuleSetBuilder.new(), &block).build
end

require 'docile'
require 'pry'

require 'ipbubbles/chain'
require 'ipbubbles/chain/destinations_builder'
require 'ipbubbles/chain/destinations'
require 'ipbubbles/chain/inputs_builder'
require 'ipbubbles/chain/inputs'
require 'ipbubbles/chain/outputs_builder'
require 'ipbubbles/chain/outputs'
require 'ipbubbles/chain/rule'
require 'ipbubbles/chain/source_ports_builder'
require 'ipbubbles/chain/source_ports'

require 'ipbubbles/table'
require 'ipbubbles/table/chains_builder'
require 'ipbubbles/table/chains'
require 'ipbubbles/table/inputs_builder'
require 'ipbubbles/table/inputs'
require 'ipbubbles/table/outputs_builder'
require 'ipbubbles/table/outputs'

require 'ipbubbles/chain_builder'
require 'ipbubbles/rule_builder'
require 'ipbubbles/rule'
require 'ipbubbles/rule_set_builder'
require 'ipbubbles/rule_set'
require 'ipbubbles/table_builder'
require 'ipbubbles/types'
require 'ipbubbles/version'