class CopyService
  # Make ActionView helpers available in copy files when renderings
  include ActionView::Helpers

  def initialize(interaction_name, hash)
    @interaction_name = interaction_name
    @context = hash_to_binding hash
  end

  def get_copy(key)
    to_render = get_copy_file(key)

    rendered = recursive_render to_render

    if rendered.is_a? String
      rendered
    else
      HashWithIndifferentAccess.new(rendered)
    end
  end

  def recursive_render(to_render)
    if to_render.is_a? String
      ERB.new(to_render).result(@context)
    elsif to_render.is_a? Hash
      to_render.each { |k, v| to_render[k] = recursive_render v }
      to_render
    elsif to_render.is_a? Array
      to_render.map { |x|  recursive_render x }
    end
  end

  def get_copy_file(key)
    sections = key.split '.'
    copy = get_interaction_yaml(@interaction_name)

    sections.each { |s| copy = copy[s] }

    # If we get an array, choose one element at random.
    copy.is_a?(Array) ? copy.sample : copy
  end

  private

  def get_interaction_yaml(name)
    path = File.join(copy_route, "#{name}.yml")

    YAML.load File.read(path)
  end

  def copy_route
    Rails.root.join 'lib/data/copy/'
  end

  def hash_to_binding(hash)
    bind = binding

    hash.each { |k, v| bind.local_variable_set(k, v) }

    bind
  end
end
