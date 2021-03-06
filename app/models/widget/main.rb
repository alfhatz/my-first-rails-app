class Widget::Main < TermTaxonomy
  default_scope { where(taxonomy: :widget) }
  attr_accessible :excerpt, :renderer
  # name: "title"
  # description: "content for this"
  # slug: "key for this"
  # status = simple or complex (default)
  # excerpt: string for message
  # renderer: string (path to the template for render this widget)

  has_many :metas, ->{ where(object_class: 'Widget::Main')}, :class_name => "Meta", foreign_key: :objectId, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  belongs_to :site, :class_name => "Site", foreign_key: :parent_id

  has_many :assigned, class_name: "Widget::Assigned", foreign_key: :visibility, dependent: :destroy
  before_save :check_excerpt
  def is_simple?
    self.status == "simple"
  end

  def excerpt=(value)
    @excerpt = value
  end
  def excerpt
    self.get_option("excerpt")
  end

  def renderer=(value)
    @renderer = value
  end
  def renderer
    self.get_option("renderer")
  end

  private
  def check_excerpt
    self.set_option("excerpt", @excerpt)
    self.set_option("renderer", @renderer)
  end
end
