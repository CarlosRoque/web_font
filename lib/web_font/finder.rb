require 'json'

module WebFont
  class Finder

    attr_reader :indices, :items

    def initialize
      @indices = read_indices
      @items   = read_fonts['items']
    end

    # Find font in the index
    #
    # Returns hash
    def find(font_family)
      font_family = font_family.downcase
      alphabet    = font_family[0]
      hash        = indices[alphabet]
      start       = hash['start']

      item = while start <= hash['end']
               break items[start] if match?(font_family, items[start]['family'])
               start += 1
             end

      item || {}
    end

    private

      def match?(font_family1, font_family2)
        font_family2 = font_family2.downcase
        font_family1 == font_family2 || font_family1 == font_family2.gsub(/\s/, '')
      end

      def read_json(filename)
        file = File.open(File.join(WebFont::Data.path, filename))
        JSON.parse(file.read)
      ensure
        file.close
      end

      def read_fonts
        read_json('fonts.json')
      end

      def read_indices
        read_json('index.json')
      end
  end
end