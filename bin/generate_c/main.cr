require "../submodules/crystal_lib/src/clang"
require "../submodules/crystal_lib/src/crystal_lib"

node = Crystal::Parser.parse(<<-EOS
module Crul
  @[Include(
    "#{ARGV[0]}/curl/curl.h",
    prefix: %w(curl_ CURL_ curl Curl CURL))]
  @[Link("curl")]
  lib C
  end
end
EOS
)
puts "Transforming..."
visitor = CrystalLib::LibTransformer.new
transformed = node.transform(visitor).to_s
transformed = transformed.gsub(": *", ": Curl*")
transformed = transformed.gsub("( :", "(curl :")
transformed = transformed.sub("alias  = Void", "alias Curl = Void")
transformed = transformed.sub(/Sockaddr(\s+family)/, "CurlSockaddr\\1")
transformed = transformed.sub("enum Msg", "enum Msg_")
puts "Writing auto_generated.c..."
File.write("#{__DIR__}/../../src/lib/c/auto_generated.cr", transformed)
