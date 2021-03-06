

module Transdifflation

  #Class used to convert all keys in a hash (included sub-hashes) in symbols
  class HashSymbolTranslator
    # Convert keys (strings) into symbols
    def symbolize(hash)
      hash = hash.inject({}) { |memo,(k,v)|
          if(v.instance_of? Hash)
             v = symbolize(v)
          end
          memo[k.to_sym] = v
          memo
      }
      hash
    end
     # Convert keys into string
     def unsymbolize(hash)
      hash = hash.inject({}) { |memo,(k,v)|
          if(v.instance_of? Hash)
             v = unsymbolize(v)
          end
          memo[k.to_s] = v
          memo
      }
      hash
    end


  end
end

# monkeypatch the Hash class to convert to/from symbols
class Hash

  #convert all keys in a Hash (presumily from YAML) in symbols
  def symbolize!
    symbolizer = Transdifflation::HashSymbolTranslator.new
    new_self = symbolizer.symbolize(self)
    self.clear
    self.merge!(new_self)
  end

  #convert all keys in a Hash (presumily from YAML) in symbols
  def unsymbolize!
    symbolizer = Transdifflation::HashSymbolTranslator.new
    new_self = symbolizer.unsymbolize(self)
    self.clear
    self.merge!(new_self)
  end

end
