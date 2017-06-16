# http://blog.mischel.com/2016/09/07/an-interesting-interview-question/

def forklift(store)
  raise unless store.keys.include?(:dt)

  store.each do |key, value|
    if key.to_s[/\d/] == value.to_s[/\d/]
      next
    else
      store[:dt] = value
      sought_value = "c#{key.to_s[/\d/]}".to_sym
      key_of_sought_value = store.key(sought_value)
      store[key] = store[key_of_sought_value]
      store[key_of_sought_value] = store[:dt]
      store[:dt] = nil
      p "key: #{key}, store: #{store}"
    end
  end
end

storage = { d1: :c4, d2: :c1, d3: :c5, d4: :c3, d5: :c2, dt: nil }
expected_result = { d1: :c1, d2: :c2, d3: :c3, d4: :c4, d5: :c5, dt: nil }

result = forklift(storage)
raise "unsorted storage" if result != expected_result

p "forklift(storage): #{result}"
