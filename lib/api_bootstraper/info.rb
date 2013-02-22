module ApiBootstraper
  module VERSION
    MAJOR = 0
    MINOR = 1
    TINY  = 0

    ARRAY  = [MAJOR, MINOR, TINY].compact.freeze
    STRING = ARRAY.join('.').freeze

    def self.to_a; ARRAY  end
    def self.to_s; STRING end
  end

  module Info
    class << self
      def name; 'ApiBootstraper' end
      def url; 'http://apibootstraper.github.com/' end
      def version; "#{ApiBootstraper::VERSION}" end
    end
  end
end