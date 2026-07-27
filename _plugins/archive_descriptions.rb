# Give auto-generated category/tag archive pages a unique meta description.
#
# jekyll-paginate-v2 autopages set a title but no description, so every archive
# fell back to site.description and SEO tools flagged them as duplicates.
# jekyll-seo-tag reads page.data["description"]; this fills a unique one, built
# from the archive's own name, before rendering begins. Runs on Cloudflare Pages
# (bundle exec jekyll build, non-safe mode). Pages with their own description are
# left untouched.
Jekyll::Hooks.register :site, :pre_render do |site|
  tail = "on Virgin or Pigeon — essays on technoshamanism, " \
         "fifth-generation warfare, cyberpunk, and Thelema."
  site.pages.each do |page|
    next unless page.data["description"].to_s.empty?
    ap = page.data["autopages"]
    next unless ap.is_a?(Hash) && !ap["display_name"].to_s.empty?
    label = ap["display_name"].tr("-", " ")
    url = page.url.to_s
    if url.start_with?("/category/")
      page.data["description"] = "Posts filed under “#{label}” #{tail}"
    elsif url.start_with?("/tag/")
      page.data["description"] = "Posts tagged “#{label}” #{tail}"
    end
  end
end
