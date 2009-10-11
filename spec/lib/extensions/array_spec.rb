require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Array do
  describe 'to_sql' do
    it 'does something' do
      [['dog', 'sneakers', 5], ['snake', 'tap shoes', 9]].to_sql.should == ["('dog', 'sneakers', 5)", "('snake', 'tap shoes', 9)"]
    end
    it 'works with nulls' do
      [['dog', 'sneakers', nil], ['snake', '', 9]].to_sql.should == ["('dog', 'sneakers', NULL)", "('snake', '', 9)"]
    end
  end
end