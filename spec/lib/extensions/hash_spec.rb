require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hash do
  describe '#import_to_sql' do
    it 'imports a hash to sql' do
      name_array = []
      category_id_array = []
      description_array = []
      hidden_array = []
      4.times do |x|
        name_array << Product.unused_attribute(:name)
        category_id_array << 5
        description_array << (x == 0 ? '#{organization.name} #{name} (#{year})' : nil)
        hidden_array << true
      end
      hash = {
        :name => name_array, 
        :category_id => category_id_array,
        :description => description_array,
        :hidden => hidden_array
      }
      hash.import_to_sql(Product)
      name_array.each_with_index do |name, index|
        product = Product.find_by_name(name)
        product.should_not be_nil
				if index == 0
					product.description.should == '#{organization.name} #{name} (#{year})'
				else
					product.description.should be_nil
				end
        product.should be_hidden
      end
    end
    # it 'imports things that are over one million characters long' do # 9000 9000 900 9000 9090
    #   Product.destroy_all(:name => '(a)')
    #   hash = {:name => []}
    #   333_334.times do
    #     hash[:name] << '(a)'
    #   end
    #   hash.import_to_sql(Product)
    #   Product.find_all_by_name('(a)').length.should == 333_334
    # end
		it "doesn't do it backwards" do
		  {:name => ['0', '1', '2', '3', '4'], :category_id => [1, 1, 1, 1, 1]}.import_to_sql(Product)
		  products = Product.all[-5..-1]
      products.collect {|x| x.name.to_i}.should == [0, 1, 2, 3, 4]
	  end
  end
  describe '#respectively_insert(other)' do
    it 'is looks up the keys on the other object and <<s each of the resulting things onto the key\'s values' do
      a = {:name => 'leopard', :category_id => 4}
      b = {:name => 'bob', :category_id => 5, :parent_id => 2, :format_string => 'silly'}
      hash = {:name => [], :category_id => [], :parent_id => []}
      hash.respectively_insert a
      hash.should == {:name => ['leopard'], :category_id => [4], :parent_id => [nil]}
      hash.respectively_insert b
      hash.should == {:name => ['leopard', 'bob'], :category_id => [4, 5], :parent_id => [nil, 2], :format_string=>[nil, 'silly']}
    end
  end
end