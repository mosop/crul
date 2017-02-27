module Crul::Safe
  module Easy
    extend Safec::Macros

    safe_c_pointer Pointer(C::Curl)

    class Free
      def free(p)
        C.easy_cleanup p
      end
    end
  end
end
