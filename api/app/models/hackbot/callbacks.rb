module Hackbot
  module Callbacks
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included do
      define_callbacks :handle
    end

    class_methods do
      def before_handle(*methods, &block)
        set_callback(:handle, :before, *methods, &block)
      end

      def after_handle(*methods, &block)
        set_callback(:handle, :after, *methods, &block)
      end
    end
  end
end
