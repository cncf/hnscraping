require "open-uri"
require "json"
require File.join(__dir__, 'job')

module JobsRepository
  def self.fetch_jobs
    post = get_latest_hiring_post
    comments = get_comments(post['objectID'])
    comments.map { |comment| Job.new(comment) }
      .select { |job| job.relevant? && job.valid? }
  end

  private

  def self.get_latest_hiring_post
    get("search_by_date?tags=story,author_whoishiring").dig("hits", 0)
  end

  def self.get_comments(post_id)
    get("items/#{post_id}").dig("children")
  end

  def self.get(path)
    JSON.parse(open("https://hn.algolia.com/api/v1/#{path}").read)
  end
end
