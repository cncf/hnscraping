# frozen_string_literal: true

module Keywords
  ROLES = [
    ['DevOps Engineer', aliases: ['DevOps']],
    ['Site Reliability Engineer', aliases: ['SRE', 'SREs', 'Site Reliability Engineers']],
    ['Infrastructure Engineer', aliases: ['Infrastructure Engineers']]
  ].freeze
end

KeywordFinder.append(:roles, Keywords::ROLES)
