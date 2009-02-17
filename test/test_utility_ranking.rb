require File.dirname(__FILE__) + '/test_helper.rb'
class MUser
  attr_accessor :name
#  cattr_accessor :all
  def initialize(name)
    @name = name
    (@@all ||= []).push(self)
  end
  def self.find(arg, options={}); @@all end # mock
  
  self.extend UtilityRanking::SingletonMethods
  include UtilityRanking::InstanceMethods #utility_rankable
  
  def utility; lambda { name.length }.call end  
end
class NameLengthValuingMUser < MUser
  def utility; lambda { name.length }.call end  
  # def find; end
end
class NameOrderValuingMUser < MUser
  def utility; lambda { (name.first.."z").to_a.size }.call end
end


class TestUtilityRanking < Test::Unit::TestCase

  def setup
    john = MUser.new("John")
    
    alphonsophecles = NameLengthValuingMUser.new("alphonsophecles")
    eric = NameLengthValuingMUser.new("eric")
    
    alf = NameOrderValuingMUser.new("alf")
    zeb = NameOrderValuingMUser.new("zeb")
  end
  
  def test_STI_safe
    assert false # i have no idea how to create a mock datamodel of STI.
  end
  
  def test_leaderboard
    assert true
  end
  def test_competitors
    assert true
  end
end
