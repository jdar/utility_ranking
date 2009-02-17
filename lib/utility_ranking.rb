#$:.unshift(File.dirname(__FILE__)) unless
#  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module UtilityRanking
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def utility_ranking
      include UtilityRanking::InstanceMethods
      extend UtilityRanking::SingletonMethods
    end
  end
   
  module SingletonMethods
    def competitors(options = {})
      options[:order] = 'utility_cache DESC' unless options[:order] || !self.first.respond_to?(:utility_cache)
      find(:all,options)
    end
    def leaderboard(options = {})
      options[:limit]= 5 unless options[:limit]
      competitors(options)
    end
    
    def cache_utilities # depends on a)rails & b)defining proc utility_function at the instance level
      raise "no objects for which to cache the utility_function" if self.count == 0
      raise "add_column #{self.to_s.pluralize.underscore}, :utility_cache, :integer, :default=>0" unless self.first.respond_to? :utility_cache
      self.transaction do
        self.all.each do |el|
          el.update_attribute :utility_cache, el.utility_function.call
        end
#      rescue => e
      end
    end
  end
  
  module InstanceMethods
    # UTILITY CALCULATIONS
    def utility_function; lambda { 0 } end #overwrite in class!

  # THINGS THAT RETURN NUMBERS
    def rank_amongst(args)
       options = case args
         when Hash; args
         when Array; {:collection => args}
       end
       options[:collection].index(self) + 1 rescue nil
    end
    def rank(options = {})
      rank_amongst(:collection=>competitors(options)) 
    end

  # THINGS THAT RETURN OBJECTS
    def competitors(options = {})
       searchable_model = options.delete(:class) # if specified..
       searchable_model ||= self.class # STI-safe (i.e., VehicleProducers will be returned for a Company with type "VehicleProducer")    
       returning(searchable_model.competitors(options)) {|comps| comps << self unless comps.include? self }
    end
    def leaderboard(options = {})
      all = self.competitors(options) 
      all = all[0..options[:limit]] if options[:limit]
      all
    end
    
    #CACHING
    def utility
      if not self.respond_to?(:utility_cache)
        utility_function.call
      else
        utility_cache
      end
    end
  end  


end