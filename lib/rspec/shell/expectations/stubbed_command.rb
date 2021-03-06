module Rspec
  module Shell
    module Expectations
      # Command that produces specific output
      # and monitors input
      class StubbedCommand
        def initialize(command, dir)
          @dir, @command = dir, command
          FileUtils.cp(stub_filepath, File.join(dir, command))
          @call_configuration = CallConfiguration.new(
            Pathname.new(dir).join("#{command}_stub.yml")
          )
          @call_log = CallLog.new(
            Pathname.new(dir).join("#{command}_calls.yml")
          )
        end

        def with_args(*args)
          StubbedCall.new(@call_configuration, @call_log, args)
        end

        def called?
          with_args.called?
        end

        def called_with_args?(*args)
          with_args.called_with_args?(*args)
        end

        def returns_exitstatus(statuscode)
          with_args.returns_exitstatus(statuscode)
        end

        def stdin
          with_args.stdin
        end

        def outputs(contents, to: :stdout)
          with_args.outputs(contents, to: to)
        end

        private

        def stub_filepath
          project_root.join('bin', 'stub')
        end

        def project_root
          Pathname.new(File.dirname(File.expand_path(__FILE__)))
            .join('..', '..', '..', '..')
        end
      end
    end
  end
end
