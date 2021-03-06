module Rspec
  module Shell
    module Expectations
      # A specific call with arguments on a StubbedCommand
      class StubbedCall
        def initialize(config, call_log, args)
          @config, @call_log, @args = config, call_log, args
        end

        def with_args(*args)
          StubbedCall.new(@config, @call_log, @args + args)
        end

        def returns_exitstatus(statuscode)
          @config.set_exitcode(statuscode, @args)
          @config.write
          self
        end

        def outputs(content, to: :stdout)
          @config.set_output(content, to, @args)
          @config.write
          self
        end

        def stdin
          return nil unless @call_log.exist?
          @call_log.stdin_for_args(*@args)
        end

        def called?
          return false unless @call_log.exist?
          @call_log.called_with_args?(*@args)
        end
      end
    end
  end
end
