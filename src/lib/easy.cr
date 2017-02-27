module Crul
  class Easy
    alias WriteCallback = Proc(LibC::Char*, LibC::SizeT, LibC::SizeT, Void*, LibC::SizeT)

    getter safe : Safe::Easy::Type
    @error_buffer = Array(UInt8).new(C::ERROR_SIZE)

    def initialize(@safe)
      C.easy_setopt @safe, C::Option::OptErrorbuffer, @error_buffer
    end

    def self.init
      h = C.easy_init
      raise SomethingWrong.new("curl_easy_init failed.") if h == Pointer(C::Curl).null
      new(Safe::Easy.free(h))
    end

    macro call(f, *args, &block)
      %result = C.{{f.id}}({{args.splat}})
      %desc = %result == C::Code::EOk ? "" : String.new(@error_buffer.to_unsafe)
      {% if block %}
        %call = ::Crul::CallError.new({{f.id.stringify}}, %result, ::String.new(::Crul::C.easy_strerror(%result)), %desc)
        ::Curl::Util.yield_with(%call) {{block}}
      {% else %}
      (if %result != C::Code::EOk
        raise ::Crul::CallError.new({{f.id.stringify}}, %result, ::String.new(::Crul::C.easy_strerror(%result)), %desc)
      else
        %result
      end)
      {% end %}
    end

    @@write_callback = WriteCallback.new do |ptr, size, nmemb, userdata|
      io = Box(IO).unbox(userdata)
      slice = Slice(LibC::Char).new(ptr, size.to_i32 * nmemb.to_i32)
      io.write slice
      size * nmemb
    end

    def perform(io : IO)
      self.writefunction = @@write_callback
      self.writedata = Box(IO).box(io)
      perform
    end

    def perform
      call :easy_perform, @safe
    end

    def writefunction=(value : WriteCallback)
      call :easy_setopt, @safe, C::Option::OptWritefunction, value
    end

    def writedata=(value : Void*)
      call :easy_setopt, @safe, C::Option::OptWritedata, value
    end

    def unix_socket_path=(value : String)
      @unix_socket_path = value
      call :easy_setopt, @safe, C::Option::OptUnixSocketPath, value
    end

    def url=(value : String)
      @url = value
      call :easy_setopt, @safe, C::Option::OptUrl, value
    end

    def header=(value : Bool)
      call :easy_setopt, @safe, C::Option::OptHeader, value ? 1 : 0
    end

    def ssl_verifypeer=(value : Bool)
      call :easy_setopt, @safe, C::Option::OptSslVerifypeer, value ? 1 : 0
    end

    def sslcert=(value : String)
      @sslcert = value
      call :easy_setopt, @safe, C::Option::OptSslcert, value
    end

    def keypasswd=(value : String)
      @keypasswd = value
      call :easy_setopt, @safe, C::Option::OptKeypasswd, value
    end

    def sslkey=(value : String)
      @sslcert = value
      call :easy_setopt, @safe, C::Option::OptSslkey, value
    end
  end
end
