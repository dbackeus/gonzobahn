module Matchers
  module ActionController

    def deny_access
      DenyAccess.new
    end
    
    class DenyAccess
      def matches?(controller)
        @controller = controller
        error_flash_set? && redirected?
      end
      
      def description
        "deny access"
      end
      
      def failure_message
        "Expected #{expectation}"
      end
      
      def negative_failure_message
        "Did not expect #{expectation}"
      end
      
      def expectation
        return "flash to be '#{expected_flash_error}' but was '#{flash[:error]}'" unless error_flash_set?
        return "redirect to '#{expected_redirect_url}' but was '#{response.redirect_url}'" unless redirected?
      end
      
      private
      def error_flash_set?
        @error_flash_set ||= flash[:error] == expected_flash_error
      end
      
      def expected_flash_error
        "You must be logged in to see this page" 
      end
      
      def redirected?
        @redirected ||= response.redirect? && response.redirect_url == expected_redirect_url
      end
      
      def expected_redirect_url
        @controller.send(:login_url)
      end
      
      def response
        @controller.response
      end
      
      def flash
        @controller.session["flash"]
      end
    end
    
  end
end