require 'test/unit'
require 'methodize/hash'
require 'methodize/array'

require 'rubygems'
require 'ruby-debug'

class MethodizeArrayTest < Test::Unit::TestCase

  def setup
    @hash = [
    {
      :article => [
        {
          :title  => "Article 1",
          :author => "John Doe",
          :url    => "http://a.url.com"
        },{
          "title"  => "Article 2",
          "author" => "Foo Bar",
          "url"    => "http://another.url.com"
        },{
          :title  => "Article 3",
          :author => "Biff Tannen",
          :url    => ["http://yet.another.url.com", "http://localhost"],
          :info => {
            :published => "2010-05-31",
            :category  => [:sports, :entertainment]
          }
        }
      ],
      "type" => :text,
      :size  => 3,
      :id    => 123456789
    }, 
    {
      :article => [
        {
          :title  => "Second Article 1",
          :author => "John Doe The Second",
          :url    => "http://a.url.com/v2"
        },{
          "title"  => "Second Article 2",
          "author" => "Foo Bar The Second",
          "url"    => "http://another.url.com/v2"
        },{
          :title  => "Second Article 3",
          :author => "Biff Tannen The Second",
          :url    => ["http://yet.another.url.com/v2", "http://localhost/v2"],
          :info => {
            :published => "2011-05-31",
            :category  => [:sports, :entertainment]
          }
        }
      ],
      "type" => :text,
      :size  => 3,
      :id    => 123456789
    }
  ]

    @hash.extend(Methodize)
    
    @array = [
        {
          :name => "John",
          :age => 21
        },
        {
          :name => "Doe",
          :age => 22
        }
      ]
      
      @array.extend(Methodize)
  end
  
  def test_methodize_with_standard_json_hash_as_methods_on_foreach
    @array.each do |member|
      assert member.name
      assert member.age
    end
  end
  
  def test_methodize_with_standard_json_hash_as_hash_on_foreach
    @array.each do |member|
      assert member[:name]
      assert member[:age]
    end
  end
  
  def test_methodize_with_standard_json_hash_as_hash_on_array
    assert_equal @array[0][:name], "John"
    assert_equal @array[0][:age], 21
    
    assert_equal @array[1][:name], "Doe"
    assert_equal @array[1][:age], 22
  end
  
  def test_methodize_with_standard_json_hash_as_methods_on_array
    assert_equal @array[0].name, "John"
    assert_equal @array[0].age, 21
    
    assert_equal @array[1].name, "Doe"
    assert_equal @array[1].age, 22
  end
  
  def test_methodize_with_foreach_accessing_as_hash
    @hash.each do |hash|
       assert hash[:article].last.has_key? :title
       assert hash[:article][1].has_key? "author"
       assert_equal hash["type"]               , :text
       assert_equal hash[:size]                , 3
       assert_nil   hash[:wrong_key]
    end
  end

  def test_methodize_with_foreach_accessing_as_method
    @hash.each do |hash|
       assert hash.article.last.title
       assert hash.article[1].author
       assert_equal hash.article.last.info.category.first, :sports
       assert_nil   hash.wrong_key
    end                 
  end
  
 def test_methodize_should_still_work_as_expected
     assert_equal @hash[0][:article].last[:title], "Article 3"
     assert_equal @hash[0][:article][1]["author"], "Foo Bar"
     assert_equal @hash[0]["type"]               , :text
     assert_equal @hash[0][:size]                , 3
     assert_nil   @hash[0][:wrong_key]
     
     assert       @hash[0].keys.include?(:size)
     assert_equal @hash[0].article.size, 3
     
     assert_equal @hash[1][:article].last[:title], "Second Article 3"
     assert_equal @hash[1][:article][1]["author"], "Foo Bar The Second"
     assert_equal @hash[1]["type"]               , :text
     assert_equal @hash[1][:size]                , 3
     assert_nil   @hash[1][:wrong_key]
     
     assert       @hash[1].keys.include?(:size)
     assert_equal @hash[1].article.size, 3
   end
 
   def test_methodize_should_support_read_of_values_as_methods
     assert_equal @hash[0].article.last.title              , "Article 3"
     assert_equal @hash[0].article[1].author               , "Foo Bar"
     assert_equal @hash[0].article.last.info.category.first, :sports
     assert_nil   @hash[0].wrong_key
     
     assert_equal @hash[0].size, 3
     assert_equal @hash[0].type, :text
     assert_equal @hash[0].id  , 123456789
   end
 
   def test_double_methodize_call_does_not_affect_anything
     assert_equal @hash.methodize![0].article.last.title, "Article 3"
   end

end
