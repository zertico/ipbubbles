require 'spec_helper.rb'

describe Ipbubbles::Rule do
  
  describe "set as simple accept rule" do
    
    subject {
      ipbubbles do
        table do
          chain do
            rule do
              jump :drop
            end
          end
        end
      end
    }
    
    it "returns iptables rule" do
      expect(subject.to_iptables).to eq("iptables -t filter -A INPUT -j DROP\n")
    end
  end
  
  describe "most complex rule example" do
    subject {
      ipbubbles do
        table do
          chain do
            rule do
              input :eth0
              output :eth1
              match :limit
              log_level 4
              log_prefix "GENERAL: "
              set_mark 1
              save_mark
              ctstate :established,:related
              jump :mark_complex_name
            end
          end
        end
      end
    }
    it "returns iptables rule" do
      expect(subject.to_iptables).to eq("iptables -t filter -A INPUT -i eth0 -o eth1 -m limit --log-level 4 --log-prefix \"GENERAL: \" --set-mark 1 --save-mark --ctstate ESTABLISHED,RELATED -j MARK-COMPLEX-NAME\n")
    end
  end
end