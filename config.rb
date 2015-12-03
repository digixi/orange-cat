###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

I18n.default_locale = :ru

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :development do
  set :relative_links, true
  activate :relative_assets
  activate :livereload
end

# Build-specific configuration
configure :build do
  set :relative_links, false
  set :http_prefix, '/orange-cat/'

  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets
end

activate :bower

activate :blog do |blog|
  blog.prefix = 'about/news'
  blog.layout = 'article'
  blog.permalink = '{year}-{month}-{day}-{title}.html'
  blog.summary_generator = proc do |context, rendered, *args|
    html = html_doc = Nokogiri::HTML('<article>' + rendered + '</article>')
    nodes = html.css('article > *')
    hr = html.at_css('article > hr')
    hr ? nodes.slice(0, nodes.index(hr)).to_html : nodes.first.to_html
  end
end

Dir['source/about/gallery/**/*'].each do |name|
  next unless File.directory?(name)
  proxy '/' + name.split('/')[1..-1].join('/') + '/index.html', '/about/gallery/index.html', locals: {folder: name}
end
