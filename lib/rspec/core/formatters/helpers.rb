module RSpec
  module Core
    module Formatters

      module Helpers
        extend self

        SUB_SECOND_PRECISION = 5
        DEFAULT_PRECISION = 2

        def format_duration(duration)
          if duration > 60
            minutes = duration.to_i / 60
            seconds = duration - minutes * 60

            "#{pluralize(minutes, 'minute')} #{format_seconds(seconds)} seconds"
          else
            "#{format_seconds(duration)} seconds"
          end
        end

        def format_seconds(float)
          precision ||= (float < 1) ? SUB_SECOND_PRECISION : DEFAULT_PRECISION
          formatted = sprintf("%.#{precision}f", float)
          strip_trailing_zeroes(formatted)
        end

        def strip_trailing_zeroes(string)
          stripped = string.sub(/[^1-9]+$/, '')
          stripped.empty? ? "0" : stripped
        end

        def pluralize(count, string)
          "#{count} #{string}#{'s' unless count == 1}"
        end

        def format_backtrace(backtrace, options = {})
          return "" unless backtrace
          return backtrace if options[:full_backtrace] == true

          if at_exit_index = backtrace.index(RSpec::Core::Runner::AT_EXIT_HOOK_BACKTRACE_LINE)
            backtrace = backtrace[0, at_exit_index]
          end

          cleansed = backtrace.map { |line| backtrace_line(line) }.compact
          cleansed.empty? ? backtrace : cleansed
        end

        def backtrace_line(line)
          return nil if RSpec.configuration.cleaned_from_backtrace?(line)
          RSpec::Core::Metadata::relative_path(line)
        rescue SecurityError
          nil
        end
      end

    end
  end
end
