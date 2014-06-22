module Ipbubbles
end

require 'docile'
require 'pry'

require 'ipbubbles/chain'
require 'ipbubbles/chain/element_builder'
require 'ipbubbles/chain/rule'

require 'ipbubbles/table'
require 'ipbubbles/table/chains_builder'
require 'ipbubbles/table/element_builder'

require 'ipbubbles/chain_builder'
require 'ipbubbles/rule_builder'
require 'ipbubbles/rule'
require 'ipbubbles/rule_set_builder'
require 'ipbubbles/rule_set'
require 'ipbubbles/table_builder'
require 'ipbubbles/types'
require 'ipbubbles/version'

def ipbubbles(&block)
  Docile.dsl_eval(Ipbubbles::RuleSetBuilder.new(), &block).build
end