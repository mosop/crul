module Crul
  class Init
    def initialize(flags)
      result = Crul::C.global_init(flags)
      if result != C::Code::EOk
        raise SomethingWrong.new(String.new(Crul::C.easy_strerror(result)))
      end
    end

    def finalize
      Crul::C.global_cleanup
    end

    @@instance = new(C::GLOBAL_SSL)
  end
end
