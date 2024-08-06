LineItem = Struct.new(:name, :price, :quantity)

class Invoice
  def initialize(line_items, tax_rate)
    @line_items = line_items
    @tax_rate = tax_rate
  end

  def total_tax
    @tax_rate * @line_items.sum do |item|
      item.price * item.quantity
    end
  end

  def total_tax2
    @total_tax ||= @tax_rate * @line_items.sum do |item|
      item.price * item.quantity
    end
  end

  def total_tax3
    return @total_tax if defined?(@total_tax)
    @total_tax = @tax_rate * @line_items.sum do |item|
      item.price * item.quantity
    end
  end
end

# サンプルデータの作成（200件）
line_items = 20000.times.map do |i|
  LineItem.new("Item #{i + 1}", rand(100..1000), rand(1..10))
end

# Invoiceオブジェクトの作成
tax_rate = 0.1  # 10%の税率
invoice = Invoice.new(line_items, tax_rate)

# 各total_taxメソッドの呼び出しと結果の表示
puts "Total tax (method 1): #{invoice.total_tax}"
puts "Total tax (method 2): #{invoice.total_tax2}"
puts "Total tax (method 3): #{invoice.total_tax3}"

# パフォーマンスの比較
require 'benchmark'

Benchmark.bm(10) do |x|
  x.report("total_tax:") { 1000.times { invoice.total_tax } }
  x.report("total_tax2:") { 1000.times { invoice.total_tax2 } }
  x.report("total_tax3:") { 1000.times { invoice.total_tax3 } }
end

# 実行結果
# Total tax (method 1): 6067079.4
# Total tax (method 2): 6067079.4
# Total tax (method 3): 6067079.4
#                  user     system      total        real
# total_tax:   0.608285   0.000583   0.608868 (  0.617579)
# total_tax2:  0.000031   0.000000   0.000031 (  0.000031)
# total_tax3:  0.000034   0.000000   0.000034 (  0.000034)
