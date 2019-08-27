# frozen_string_literal: true

module Facter
  module Opensuse
    class OsFamily
      FACT_NAME = 'os.family'

      def call_the_resolver
        fact_value = UnameResolver.resolve(:family)

        Fact.new(FACT_NAME, fact_value)
      end
    end
  end
end
