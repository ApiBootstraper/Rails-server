require 'active_support/configurable'

module ApiBootstraper

  class << self
    # Global settings for ApiBootstraper
    def config
      @config ||= ApiBootstraper::Configuration.load
    end
  end

  # See: http://pullmonkey.com/2008/01/06/convert-a-ruby-hash-into-a-class-object/
  class Configuration
    def self.load
      Configuration.new(YAML.load_file("#{Rails.root}/config/configs.yml")[Rails.env]).freeze
    end

    # Parse the format of config file
    def initialize(hash)
      hash.each do |k,v|
        case v
          when Hash; self.instance_variable_set("@#{k}", Configuration.new(v))
          else; self.instance_variable_set("@#{k}", v)
        end
        self.class.send(:define_method, k, proc{ self.instance_variable_get("@#{k}") })
        # self.class.send(:define_method, "#{k}=", proc{ |v| self.instance_variable_set("@#{k}", v)})
      end
    end
  end
end