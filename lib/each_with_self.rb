class Array
  # does not work
  def each_with_self &block
    proc do |o|
      o.instance_eval do
        each { block.call }
      end
    end.call(self)
  end
end

class Hash
  def fmap &block
    self.reduce({}) {|memo, (k,v)| memo.merge!({k => block.call(v)})}
  end
  def map_on_keys &block
    self.reduce({}) {|memo, (k,v)| memo.merge!({block.call(k) => v})}
  end
  def map_on_pairs &block
    self.reduce({}) do |memo, (k,v)|
      memo.merge!({
      block.call(k) => block.call(v)
    })
    end
  end
end
