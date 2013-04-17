module ModelExtensions::Paginable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def paginate(*opts)
      @request_params = opts.size == 0 ? {} : opts.extract_options!
      offset_limit = get_offset_and_limit

      self.offset(offset_limit[:offset]).limit(offset_limit[:limit])
    end

    def total_count
      self.offset(nil).limit(nil).count
    end

    def offset_value
      return @params[:offset]
    end

    def limit_value
      return @params[:limit]
    end

    def page_value
      return @params[:limit]
    end

    private
      attr_accessor :request_params, :params

      # Returns offset and limit used to retrieve objects
      # for an API response based on offset, limit and page parameters
      # (See: https://github.com/redmine/redmine/blob/2.2-stable/app/controllers/application_controller.rb#L470)
      def get_offset_and_limit
        if @request_params[:offset].present?
          offset = @request_params[:offset].to_i
          offset = 0 if offset < 0
        end

        limit = @request_params[:limit].to_i
        if limit < 1
          limit = 25
        elsif limit > 100
          limit = 100
        end

        if offset.nil? && @request_params[:page].present?
          offset = (@request_params[:page].to_i - 1) * limit
          offset = 0 if offset < 0
        end

        offset ||= 0

        @params = {offset: offset, limit: limit}
      end
  end
end