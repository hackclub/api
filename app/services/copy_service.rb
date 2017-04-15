class CopyService
  # Make ActionView helpers available in copy files when renderings
  include ActionView::Helpers

  def initialize(interaction_name, hash)
    @interaction_name = interaction_name
    @context = hash_to_binding hash
  end

  def get_copy(key)
    to_render = get_erb(key)

    if to_render.is_a? String
      ERB.new(to_render).result(@context)
    else
      to_render = to_render.to_yaml
      rendered = ERB.new(to_render).result(@context)

      HashWithIndifferentAccess.new(YAML.load(rendered))
    end
  end

  def get_erb(key)
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
    b = binding

    hash.each { |k, v| b.local_variable_set(k, v) }

    b
  end
end
