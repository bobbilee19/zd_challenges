class Blog
  attr_accessor :posts
 
  def initialize(name, footer)
    @name = name
    @footer = footer
    @posts = []
  end
 
  def formatted_name
    "<div><h1>#{@name}</h1></div>"
  end
 
  def formatted_footer
    "<div>#{@footer}</div>"
  end
 
  def render
    puts self.formatted_name
    posts.map(&:render).join("\n")
    puts self.formatted_footer
  end
end
 
class Post 
  attr_accessor :comments
 
  def initialize(title)
    @title = title
    @comments = []
  end

  def formatted_title
    @title = @title.nil? ? 'Needs title' : @title.upcase
    "<div><p>#{@title}</p></div>"
   end
 
  def render
    puts formatted_title
    puts comments.map(&:render).join("\n")
  end
end
 
class Comment

  def initialize(content)
    @content = content
  end
 
  def render
    @content
  end
end
 
blog = Blog.new("Bobbilee's Blog", "Copyright Wobble (2012)")
 
post_1 = Post.new("I like Stuff")
post_2 = Post.new("I like Bananas")
post_3 = Post.new(nil)
 
post_1.comments.push Comment.new("Dogs are awesome")
post_2.comments.push Comment.new("Typos are awesome")
post_3.comments.push Comment.new("wibbles are wobble")
post_3.comments.push Comment.new("yay")
 
blog.posts.push post_1, post_2, post_3
 
blog.render