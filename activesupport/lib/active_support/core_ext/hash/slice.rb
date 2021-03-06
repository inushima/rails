# frozen_string_literal: true

class Hash
  # Slices a hash to include only the given keys. Returns a hash containing
  # the given keys.
  #
  #   { a: 1, b: 2, c: 3, d: 4 }.slice(:a, :b)
  #   # => {:a=>1, :b=>2}
  #
  # This is useful for limiting an options hash to valid keys before
  # passing to a method:
  #
  #   def search(criteria = {})
  #     criteria.assert_valid_keys(:mass, :velocity, :time)
  #   end
  #
  #   search(options.slice(:mass, :velocity, :time))
  #
  # If you have an array of keys you want to limit to, you should splat them:
  #
  #   valid_keys = [:mass, :velocity, :time]
  #   search(options.slice(*valid_keys))
  def slice(*keys)
    keys.each_with_object(Hash.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  end unless method_defined?(:slice)

  # Replaces the hash with only the given keys.
  # Returns a hash containing the removed key/value pairs.
  #
  #   hash = { a: 1, b: 2, c: 3, d: 4 }
  #   hash.slice!(:a, :b)  # => {:c=>3, :d=>4}
  #   hash                 # => {:a=>1, :b=>2}
  def slice!(*keys)
    omit = slice(*self.keys - keys)
    hash = slice(*keys)
    hash.default      = default
    hash.default_proc = default_proc if default_proc
    replace(hash)
    omit
  end

  # Removes and returns the key/value pairs matching the given keys.
  #
  #   { a: 1, b: 2, c: 3, d: 4 }.extract!(:a, :b) # => {:a=>1, :b=>2}
  #   { a: 1, b: 2 }.extract!(:a, :x)             # => {:a=>1}
  def extract!(*keys)
    keys.each_with_object(self.class.new) { |key, result| result[key] = delete(key) if has_key?(key) }
  end
end
