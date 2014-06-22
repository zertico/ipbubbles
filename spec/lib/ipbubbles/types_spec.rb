require 'spec_helper.rb'

# to avoid extensive unecessary tests on all Ipbubbles::Types @@data
# tests for valid targets, add/remove chains were created for table mangle
# as being the most complex one
# take care to keep Ipbubbles::Types working if you change
# @@data[:all] = [:accept]
# @@data[:mangle][:all] = [:mark]
# @@data[:mangle][:forward] = [:mirror]

describe Ipbubbles::Types do
  describe "tables" do
    describe "#valid_target?" do
      [:accept, :drop, :log, :netmap, :queue, :return, :same, :tcpmss, :ulog].each do |target|
        it "returns #{target} as valid" do
          expect(Ipbubbles::Types.valid_target? target).to eq(true)
        end
      end
    end
    [:filter, :nat, :mangle, :raw].each do |table|
      it "has #{table}" do
        expect(Ipbubbles::Types.has_table? table).to eq(true)
      end
    end
  end
  
  describe "table filter" do
    [:input, :output, :forward].each do |chain|
      it "returns true for has_chain? #{chain}" do
        expect(Ipbubbles::Types.has_chain?(:filter, chain)).to eq(true)
      end
    end
  end
  
  describe "table nat" do
    [:prerouting, :postrouting, :output].each do |chain|
      it "returns true for has_chain? #{chain}" do
        expect(Ipbubbles::Types.has_chain?(:nat, chain)).to eq(true)
      end
    end
  end
  
  describe "table mangle" do
    [:prerouting, :output, :forward, :input, :postrouting].each do |chain|
      it "returns true for has_chain? #{chain}" do
        expect(Ipbubbles::Types.has_chain?(:mangle, chain)).to eq(true)
      end
    end
    
    [:accept, :mark].each do |target|
      it "returns true for #valid_target_for_table? #{target}" do
        expect(Ipbubbles::Types.valid_target_for_table?(:mangle, target)).to eq(true)
      end
    end
    
    describe "chain forward" do
      [:mirror, :mark, :accept].each do |target|
        it "returns true for #valid_target_for_chain? #{target}" do
          expect(Ipbubbles::Types.valid_target_for_chain?(:mangle, :forward, target)).to eq(true)
        end
      end
    end
    
    describe "chains" do
      it "returns false for chain that does not exist" do
        expect(Ipbubbles::Types.has_chain?(:mangle, :foo)).to eq(false)
      end
      
      it "returns true after adding a chain" do
        expect(Ipbubbles::Types.add_chain(:mangle, :foo)).to eq(true)
        Ipbubbles::Types.remove_chain(:mangle, :foo)
      end
      
      it "returns false if remove a chain that does not exist" do
        expect(Ipbubbles::Types.remove_chain(:mangle, :foo)).to eq(nil)
      end
      
      it "returns that exists after chain being added" do
        Ipbubbles::Types.add_chain(:mangle, :foo)
        expect(Ipbubbles::Types.has_chain?(:mangle, :foo)).to eq(true)
        Ipbubbles::Types.remove_chain(:mangle, :foo)
      end
    end
  end
  
  describe "table raw" do
    [:prerouting, :output].each do |chain|
      it "returns true for #has_chain? #{chain}" do
        expect(Ipbubbles::Types.has_chain?(:raw, chain)).to eq(true)
      end
    end
  end
end