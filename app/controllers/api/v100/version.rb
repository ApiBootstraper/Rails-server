module Api::V100
  module VERSION
    MAJOR = 1
    MINOR = 0
    PATCH = 0

    ARRAY    = [MAJOR, MINOR, PATCH].compact.freeze
    STRING   = ARRAY.join('.').freeze

    def self.to_a; ARRAY end
    def self.to_s; STRING end
    def self.without_patch; [MAJOR, MINOR].compact.join('.').freeze end
  end
end