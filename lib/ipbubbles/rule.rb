class Ipbubbles::Rule

  def initialize(name, opts)
    @name = name
    @opts = opts
    sanitize_options
  end

  def to_iptables
    if @name.nil?
      rule = "iptables -t "+@opts[:table].to_s+" -A "+@opts[:chain].to_s.upcase!.gsub(/_/,"-")
    else
      rule = "# #{@name}\n"
      rule << "iptables -t "+@opts[:table].to_s+" -A "+@opts[:chain].to_s.upcase!.gsub(/_/,"-")
    end
    
    process_opts = @opts.clone
    process_opts.delete(:table)
    process_opts.delete(:chain)
    
    process_opts.each do |option, value|
      # I really don't like to make many nested IFs
      # If some one can propose better approach, please PR
      
      # Add option to iptables chain
      rule << " " + iptables_option(option)
      
      # Unless is a toggler
      unless value.is_a? TrueClass
        # If value need to be processed
        if respond_to?("process_"+option.to_s, true)
          processed_value = send("process_"+option.to_s, value)
        else
          processed_value = value.to_s
        end
        
        # If is a String, we put value between quotes
        if value.is_a? String
          rule << " \"#{processed_value}\""
        else
          rule << " #{processed_value}"
        end
      end
    end
    
    rule + "\n"
  end
  
  private
  def process_icmp_type value
    value.to_s.gsub(/_/,"-")
  end
  
  def process_jump value
    value.to_s.upcase!.gsub(/_/,"-")
  end
  
  def process_limit_per_second value
    value.to_s + "/second"
  end
  
  def process_limit_per_minute value
    value.to_s + "/minute"
  end
  
  def process_limit_per_hour value
    value.to_s + "/hour"
  end
  
  def process_limit_per_day value
    value.to_s + "/day"
  end
  
  def process_destination value
    network_process value
  end
  
  def process_not_destination value
    network_process value
  end
  
  def process_source value
    network_process value
  end
  
  def process_tcp_flags value
    if value.is_a? Array
      value.map! { |x| x.to_s.upcase }
      value.join(",")
    else
      value.to_s.upcase!
    end
  end
  
  def process_ctstate value
    state_process value
  end
  
  def process_source_port value
    case value
    when :domain; return 53
    when :ntp; return 123
    end
  end
  
  def process_state value
    state_process value
  end
  
  def state_process value
    if value.is_a? Array
      value.map! { |x| x.upcase }
      value.join(",")
    else
      value.to_s.upcase!
    end
  end
  
  def network_process value
    if value.count > 1
      value.join("/")
    else
      value.first
    end
  end
  
  def iptables_option option
    case option
    when :input; return "-i"
    when :output; return "-o"
    when :destination; return "-d"
    when :destination_port; return "--dport"
    when :source; return "-s"
    when :icmp_type; return "--icmp-type"
    when :protocol; return "-p"
    when :syn; return "--syn"
    when :match; return "-m"
    when :limit_per_second; return "--limit"
    when :limit_per_minute; return "--limit"
    when :limit_per_hour; return "--limit"
    when :limit_per_day; return "--limit"
    when :log_level; return "--log-level"
    when :log_prefix; return "--log-prefix"
    when :set_mark; return "--set-mark"
    when :accept; return "-j ACCEPT"
    when :save_mark; return "--save-mark"
    when :restore_mark; return "--restore-mark"
    when :ctstate; return "--ctstate"
    when :state; return "--state"
    when :tcp_flags; return "--tcp-flags"
    when :source_port; return "--source-port"
    when :not_destination; return "! -d"
    when :jump; return "-j"
    else
      raise Exception, "#{option} is not a valid Ipbubbles::Rule option"
    end
  end
  
  def sanitize_options
    # validations here
  end
end

# def rule(&block)
#   Docile.dsl_eval(Ipbubbles::RuleBuilder.new(), &block).build
# end