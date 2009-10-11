require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Crewait do
  describe '::start_waiting and ::go!' do
    it '::start_waiting creates a new Crewait session and ::go! saves everything that\'s been crewaited since you started waiting' do
      name = Product.unused_attribute(:name)
      next_insert_id = Product.next_insert_id
      Crewait.start_waiting
      product = Product.crewait(
        :name => name,
        :category_id => 3,
        :stay_a_hash => true,
        :hidden => true
      )
      Product.find_by_name(name).should be_nil
      product.id.should_not be_nil
      product.id.should == next_insert_id
      Crewait.go!
      found_product = Product.find_by_name(name)
      found_product.should_not be_nil
      found_product.id.should == next_insert_id
      found_product.should be_hidden
    end
		it 'works on this case with parentheses' do
			Crewait.start_waiting
			Product.crewait(
        :model_name => 'dog',
        :parent_id => 5,
        :organization_id => 7,
        :year => '2009',
        :name_format => '#{organization.name} #{name} (#{year})'
      )
			Product.crewait(
        :model_name => 'dog',
        :parent_id => 5,
        :organization_id => 7,
        :year => '2009',
        :name_format => '#{organization.name} #{name} (#{year})'
      )
			Crewait.go!
		end
		it 'handles multiple objects and relationships between each other' do
      Crewait.start_waiting
      array = []
		  5.times do |number|
		    array << (product = Product.crewait(:name => number.to_s, :category_id => 1))
	    end
	    array.each_with_index do |product, index|
	      Interaction.crewait(:basic_verb => index.to_s, :verb => index.to_s, :product_id => product.id)
      end
      Crewait.go!
      products = Product.all[-5..-1]
      products.collect {|x| x.name.to_i}.should == [0, 1, 2, 3, 4]
      products.each {|x| x.name.should == x.interactions.first.verb}
	  end
  end
end