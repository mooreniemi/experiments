require 'minitest/autorun'

class Hash
  def get_value(default, *args)
    return default if args.select! {|a| deep(a)}
    args.inject(self) {|m,i| m.send(:[],i)}
  end
  def deep(key)
    result = key?(key) ? key : self.values.map {|v| v.deep(key) if v.respond_to?(:key?)}
    result.reject! {|e| e.nil? || e.empty?} && result.flatten if result.is_a? Array
    result.is_a?(Array) ? result.first : result
  end
end


class Test < Minitest::Test
  def setup
    @config = { :files => { :mode => "foo" },
                :foo => {:fee => {:fi => "fo"}},
                :name => "config" }
  end

  def test_all_tests
    assert_equal(@config.deep(:files),:files,"deep find helper method 1")
    assert_equal(@config.deep(:mode),:mode,"deep find helper method 2")
    assert_equal(@config.deep(:fi),:fi,"deep find helper method 3")
    assert_equal(@config.get_value( 80, :port ), 80, "use default")
    assert_equal(@config.get_value( "cfg", :files, :extension ), "cfg", "use default")
    assert_equal(@config.get_value( 0x0, :files, :mode ), "foo", "first example")
    assert_equal(@config.get_value( 0x0, :foo, :fee, :fi ), "fo", "second example")
  end
end
