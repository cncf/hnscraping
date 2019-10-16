# frozen_string_literal: true

require 'loofah'
require File.join(__dir__, 'keywords')

class Job
  APPLY_URL_REGEX = /careers|jobs|greenhouse\.io|grnh\.se|lever\.co|workable\.com|applytojob\.com|recruitee\.com/

  attr_reader :id, :description

  ROLES = {
    'DevOps Engineer' => /\bdevops\b/i,
    'Site Reliability Engineer' => /\bSREs?\b|\bSite Reliability Engineers?\b/i,
    'Infrastructure Engineer' => /\bInfrastructure Engineers?\b/i
  }.freeze

  def initialize(attrs)
    @id = "hacker-news/#{attrs.fetch('id')}"
    @description = attrs.fetch('text')
  end

  def relevant?
    description && description.match?(/kubernetes|k8s/i)
  end

  def valid?
    description && company && role && location && (apply_email || apply_url)
  end

  def company
    return unless first_line.count('|') > 1

    @company ||= first_line.split('|').first.gsub(/\(.*/, '').strip
  end

  def role
    @role ||= get_first_match(description, ROLES)
  end

  def location
    @location ||= get_first_match(sanitized_description, Keywords::LOCATIONS)
  end

  def company_url
    return unless first_line.count('|') > 1

    @company_url ||= description.split('</p>').first.gsub('<p>', '').scan(/href="([^"]*)"/).flatten.first
  end

  def apply_email
    @apply_email ||= extract_email(description) || extract_email(description.gsub(/\W+at\W+/, '@').gsub(/\W+dot\W+/, '.'))
  end

  def apply_url
    @apply_url ||= all_apply_urls.length == 1 ? all_apply_urls.first : find_apply_url
  end

  def sanitized_description
    @sanitized_description ||= Loofah.fragment(description).to_text.strip
  end

  private

  def get_first_match(text, collection)
    first_match = nil
    match_position = text.length

    collection.each do |name, regex|
      index = text.index(regex)
      next if !index || index >= match_position
      match_position = index
      first_match = name
      text = text[0...match_position]
      return first_match if match_position.zero?
    end
    first_match
  end

  def first_line
    @first_line ||= sanitized_description.split("\n").first
  end

  def extract_email(text)
    text.scan(/[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+/i).flatten.first
  end

  # Finds all apply URLs from the entire description
  def all_apply_urls
    @all_apply_urls ||= extract_apply_urls(description)
  end

  # finds apply URL from first paragraph that contains DevOps, SRE or Infrastructure
  def find_apply_url
    return if all_apply_urls.empty?

    description.split("</p>").each do |paragraph|
      if paragraph.match?(/devops|\bsre\b|infrastructure\sengineer/i)
        url = extract_apply_urls(paragraph).first
        return url if url
      end
    end

    all_apply_urls.first
  end

  # extracts apply URL from a blob of text
  def extract_apply_urls(text)
    text.scan(/href="([^"]*)"/)
      .flatten
      .select { |url| url.match?(APPLY_URL_REGEX) }
      .uniq
  end
end
