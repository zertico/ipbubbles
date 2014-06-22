require 'spec_helper.rb'

describe "Load Balancer" do
  it "rule" do
    rule = ipbubbles do
      table do
        chain :dropgen do
          rule do
            jump :log
            match :limit
            limit_per_minute 1
            log_level 4
            log_prefix "GENERAL: "
          end

          # or simply 'drop'
          rule do
            jump :drop
          end
        end
      end
    end.to_iptables

    expect(rule).to eq("iptables -t filter -N DROPGEN
iptables -t filter -A DROPGEN -j LOG -m limit --limit 1/minute --log-level 4 --log-prefix \"GENERAL: \"
iptables -t filter -A DROPGEN -j DROP\n")
end

  it "rule" do
    rule = ipbubbles do
      table :mangle do
        chain :mark_projesom do
          rule do
            jump :mark
            set_mark 1
          end

          rule do
            jump :connmark
            save_mark
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t mangle -N MARK-PROJESOM
iptables -t mangle -A MARK-PROJESOM -j MARK --set-mark 1
iptables -t mangle -A MARK-PROJESOM -j CONNMARK --save-mark\n")
  end

  it "rule" do
    rule = ipbubbles do
      table :mangle do
        chain :prerouting do

          input :eth0
          match :conntrack

          rule do
            ctstate :new
            jump :mark_projesom
          end

          rule do
            ctstate :established,:related
            jump :connmark
            restore_mark
          end

          input :eth1
          rule do
            ctstate :new
            jump :mark_velox
          end

          rule do
            ctstate :established,:related
            jump :connmark
            restore_mark
          end

          input :eth2
          rule do
            ctstate :new
            jump :mark_projesom
          end

          rule do
            ctstate :established,:related
            jump :connmark
            restore_mark
          end
        end
      end
    end.to_iptables

    expect(rule).to eq("iptables -t mangle -A PREROUTING -i eth0 -m conntrack --ctstate NEW -j MARK-PROJESOM
iptables -t mangle -A PREROUTING -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j CONNMARK --restore-mark
iptables -t mangle -A PREROUTING -i eth1 -m conntrack --ctstate NEW -j MARK-VELOX
iptables -t mangle -A PREROUTING -i eth1 -m conntrack --ctstate ESTABLISHED,RELATED -j CONNMARK --restore-mark
iptables -t mangle -A PREROUTING -i eth2 -m conntrack --ctstate NEW -j MARK-PROJESOM
iptables -t mangle -A PREROUTING -i eth2 -m conntrack --ctstate ESTABLISHED,RELATED -j CONNMARK --restore-mark\n")
  end

  it "rule" do
    rule = ipbubbles do
      table :mangle do
        chain :prerouting do
          match :conntrack

          inputs [:eth0, :eth2] do
            rule do
              ctstate :new
              jump :mark_projesom
            end

            rule do
              ctstate :established,:related
              jump :connmark
              restore_mark
            end
          end

          input :eth1
          rule do
            ctstate :new
            jump :mark_velox
          end

          rule do
            ctstate :established,:related
            jump :connmark
            restore_mark
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t mangle -A PREROUTING -m conntrack -i eth0 --ctstate NEW -j MARK-PROJESOM
iptables -t mangle -A PREROUTING -m conntrack -i eth2 --ctstate NEW -j MARK-PROJESOM
iptables -t mangle -A PREROUTING -m conntrack -i eth0 --ctstate ESTABLISHED,RELATED -j CONNMARK --restore-mark
iptables -t mangle -A PREROUTING -m conntrack -i eth2 --ctstate ESTABLISHED,RELATED -j CONNMARK --restore-mark
iptables -t mangle -A PREROUTING -m conntrack -i eth1 --ctstate NEW -j MARK-VELOX
iptables -t mangle -A PREROUTING -m conntrack -i eth1 --ctstate ESTABLISHED,RELATED -j CONNMARK --restore-mark\n")
  end

  it "rule" do
    rule = ipbubbles do
      table :filter do
        chain :input do
          rule do
            input :lo
            jump :accept
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A INPUT -i lo -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :output do
          rule do
            output :lo
            jump :accept
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A OUTPUT -o lo -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :input do
          rule do
            input :lo
            accept
          end
        end
        chain :output do
          rule do
            output :lo
            accept
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :input do
          rule do
            destination "127.0.0.0", "8"
            jump :dropperm
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A INPUT -d 127.0.0.0/8 -j DROPPERM\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chains [:input, :forward] do
          rule do
            match :state
            state :established,:related
            jump :accept
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chains [:input, :forward] do
          rule do
            protocol :tcp
            tcp_flags :syn,:ack
            jump :accept
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A INPUT -p tcp --tcp-flags SYN,ACK -j ACCEPT
iptables -t filter -A FORWARD -p tcp --tcp-flags SYN,ACK -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :forward do
          rule do
            protocol :tcp
            tcp_flags :syn,:ack,:fin,:rst
            jump :accept
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :input do
          protocol :icmp
          icmp_type :echo_request

          rule do
            match :limit
            limit_per_second 1
            jump :accept
          end

          rule do
            jump :dropflood
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/second -j ACCEPT
iptables -t filter -A INPUT -p icmp --icmp-type echo-request -j DROPFLOOD\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :input do
          input :eth0
          source "192.168.0.0", "16"
          rule { jump :accept }
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A INPUT -i eth0 -s 192.168.0.0/16 -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :output do
          destinations [["192.168.0.0", "16"], ["255.255.255.255", "32"]] do
            rule do
              output :eth0
              jump :accept
            end
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A OUTPUT -d 192.168.0.0/16 -o eth0 -j ACCEPT
iptables -t filter -A OUTPUT -d 255.255.255.255/32 -o eth0 -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :output do
          rule do
            protocol :udp
            source "192.168.0.0", "16"
            jump :accept
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A OUTPUT -p udp -s 192.168.0.0/16 -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        outputs [:eth1, :eth2] do
          chain :forward do
            rule do
              input :eth0
              source "192.168.0.0", "16"
              not_destination "192.168.0.0", "16" # we need a way to negate, not necessary this way
              jump :accept
            end
          end

          chain :output do
            rule do
              not_destination "192.168.0.0", "16"
              jump :accept
            end
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A FORWARD -o eth1 -i eth0 -s 192.168.0.0/16 ! -d 192.168.0.0/16 -j ACCEPT
iptables -t filter -A FORWARD -o eth2 -i eth0 -s 192.168.0.0/16 ! -d 192.168.0.0/16 -j ACCEPT
iptables -t filter -A OUTPUT -o eth1 ! -d 192.168.0.0/16 -j ACCEPT
iptables -t filter -A OUTPUT -o eth2 ! -d 192.168.0.0/16 -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :output do
          rule { jump :dropspoof }
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A OUTPUT -j DROPSPOOF\n")
  end

  it "rule" do
    rule = ipbubbles do
      table :nat do
        chain :postrouting do
          outputs [:eth1, :eth2] do
            rule { jump :masquerade }
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :input do
          protocol :udp
          source_ports [:domain, :ntp] do
            rule { jump :accept }
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A INPUT -p udp --source-port 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --source-port 123 -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :input do
          protocol :tcp
          source "192.168.0.0", "16"
          syn
          destination_port :ssh
          rule { jump :accept }
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A INPUT -p tcp -s 192.168.0.0/16 --syn --dport ssh -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :input do
          protocol :tcp
          source "192.168.0.0", "16"
          syn
          destination_port :ssh
          rule "accept connections on port ssh from 192.168.0.0" do
            jump :accept
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("# accept connections on port ssh from 192.168.0.0
iptables -t filter -A INPUT -p tcp -s 192.168.0.0/16 --syn --dport ssh -j ACCEPT\n")
  end

  it "rule" do
    rule = ipbubbles do
      table do
        chain :forward do
          protocol :udp
          destination "192.168.0.0", "16"
          source_ports [:domain, :ntp] do
            rule { jump :accept }
          end
        end
      end
    end.to_iptables
    expect(rule).to eq("iptables -t filter -A FORWARD -p udp -d 192.168.0.0/16 --source-port 53 -j ACCEPT
iptables -t filter -A FORWARD -p udp -d 192.168.0.0/16 --source-port 123 -j ACCEPT\n")
  end
end