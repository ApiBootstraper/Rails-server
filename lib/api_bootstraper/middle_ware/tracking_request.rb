module ApiBootstraper
  module MiddleWare
    class TrackingRequest

      def initialize(app)
        @app = app
      end

      def call(env)
        before_call(env)
        response = @app.call(env)
        after_call(env, response)
      end

    private
      #
      # Before call app
      #
      def before_call(env)
        start = Time.now
        # TODO replace TrackingObject by Tracking ...
        env['tracking'] = TrackingObject.new
      end

      #
      # After call app
      #
      def after_call(env, response)
        status, headers, body = response
        request = ActionDispatch::Request.new(env)

        if status == 401 \
            || env['action_dispatch.request.parameters'].nil? \
            || !env['action_dispatch.request.parameters']['controller'].start_with?("api")

          return response
        end

        @tracking = Tracking.new({
          :request      => request.original_fullpath,
          :method       => request.method,
          :remote_ip    => request.ip,
          :uuid         => request.uuid,
          # :params       => request.query_parameters,

          # :user_agent   => request.user_agent,

          :version      => env['tracking'].current_version.to_s || "unknown",
          :application  => env['tracking'].application || nil,
          :user         => env['warden'].user || nil,
          :code         => status,

          # :headers  => headers,
          # :etag     => headers['ETag'],

          # :runtime  => Time.now - start
        })
        # Rails.logger.info headers
        # Rails.logger.info request.query_parameters

        save_tracking(env) unless @tracking.nil?

        return response
      end

      #
      # Save the tracking object
      #
      def save_tracking(env)
        if Rails.env.development?
          @tracking.save
        else
          Thread.new() do
            @tracking.save
          end
        end
      end

    end

    class TrackingObject
      attr_accessor :current_version, :current_user, :application
    end
  end
end