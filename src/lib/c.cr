require "./c/*"

module Crul
  lib C
    GLOBAL_SSL = 1 << 0
    GLOBAL_WIN32 = 1 << 1
    GLOBAL_ALL = GLOBAL_SSL | GLOBAL_WIN32
    GLOBAL_DEFAULT = GLOBAL_ALL
    GLOBAL_ACK_EINTR = 1 << 2
  end
end
