# module Crul
#   module Safe
#     macro call(f, *args, &block)
#       %result = C.{{f.id}}({{args.splat}})
#       {% if block %}
#         %call = ::Crul::Safe::Call.new({{f.id.stringify}}, %result, C.giterr_last)
#         ::Crul::Util.yield_with(%call) {{block}}
#       {% else %}
#       (if %result < 0
#         raise ::Git::Safe::CallError.new({{f.id.stringify}}, %result, C.giterr_last)
#       else
#         %result
#       end)
#       {% end %}
#     end
#   end
# end
