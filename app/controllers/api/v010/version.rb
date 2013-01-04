module Api::V010
  module VERSION
    MAJOR = 0
    MINOR = 1
    PATCH = 0

    ARRAY    = [MAJOR, MINOR, PATCH].compact.freeze
    STRING   = ARRAY.join('.').freeze

    def self.to_a; ARRAY end
    def self.to_s; STRING end
    def self.without_path; [MAJOR, MINOR].compact.join('.').freeze end
  end
end