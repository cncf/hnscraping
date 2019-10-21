module DebugHelper
  def linkify(url)
    %{<a href="#{url}">#{url}</a>}
  end
end
