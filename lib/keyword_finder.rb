class KeywordFinder
  def self.first(kind, text)
    first_match = nil
    match_position = text.length

    @keywords[kind].each do |name, finder|
      index = finder.is_a?(Regexp) ? text.index(finder) : finder.call(text)
      next if !index || index >= match_position
      match_position = index
      first_match = name
      text = text[0...match_position]
      return first_match if match_position.zero?
    end

    first_match
  end

  def self.includes?(kind, keyword, text)
    _, finder = @keywords[kind].detect { |name, _| name == keyword }
    index = finder.is_a?(Regexp) ? text.index(finder) : finder.call(text)
    !index.nil?
  end

  def self.append(kind, collection)
    @keywords ||= {}

    @keywords[kind] = collection.map do |name, extra = {}|
      finder = extra[:finder] || prepare_regexp(name, extra[:aliases] || [])
      [name, finder]
    end
  end

  def self.prepare_regexp(name, aliases)
    Regexp.new('\b' + ([name] + aliases).join('\b|\b') + '\b', true)
  end
end

require_relative File.join('keywords', 'locations')
require_relative File.join('keywords', 'roles')
