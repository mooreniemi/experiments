require 'benchmark'

domains = [
  { "country" => "Germany"},
  {"country" => "United Kingdom"},
  {"country" => "Hungary"},
  {"country" => "United States"},
  {"country" => "France"},
  {"country" => "Germany"},
  {"country" => "Slovakia"},
  {"country" => "Hungary"},
  {"country" => "United States"},
  {"country" => "Norway"},
  {"country" => "Germany"},
  {"country" => "United Kingdom"},
  {"country" => "Hungary"},
  {"country" => "United States"},
  {"country" => "Norway"}
]


Benchmark.bm do |x|
  x.report do
    domains.each_with_object(Hash.new{|h,k|h[k]='0'}) do |h,res|
      res[h['country']].succ!
    end
  end
end
