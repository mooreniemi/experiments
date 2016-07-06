require 'spec_helper'
require 'rantly/rspec_extensions'
require 'string_permutations_iterative'

# for checking test cases easily
# http://users.telenet.be/vdmoortel/dirk/Maths/permutations.html

describe String do
  describe "#permutations" do
    it 'does the minimum swap for 2 elements' do
      expect('ab'.permutations).to match_array(%w{ ab ba })
    end
    it 'returns all permutations of a length 3 string' do
      expect('ABC'.permutations).to match_array(%w{ ABC ACB BAC BCA CBA CAB })
    end
    it 'works for strings of length 4 and 5' do
      expect('abcd'.permutations).to match_array(%w{ abcd abdc acbd acdb adbc adcb bacd badc bcad bcda bdac bdca cabd cadb cbad cbda cdab cdba dabc dacb dbac dbca dcab dcba })
      expect('doggo'.permutations).to match_array([
        "dggoo", "dggoo", "dggoo", "dggoo", "dgogo",
        "dgogo", "dgogo", "dgogo", "dgoog", "dgoog",
        "dgoog", "dgoog", "doggo", "doggo", "doggo",
        "doggo", "dogog", "dogog", "dogog", "dogog",
        "doogg", "doogg", "doogg", "doogg", "gdgoo",
        "gdgoo", "gdgoo", "gdgoo", "gdogo", "gdogo",
        "gdogo", "gdogo", "gdoog", "gdoog", "gdoog",
        "gdoog", "ggdoo", "ggdoo", "ggdoo", "ggdoo",
        "ggodo", "ggodo", "ggodo", "ggodo", "ggood",
        "ggood", "ggood", "ggood", "godgo", "godgo",
        "godgo", "godgo", "godog", "godog", "godog",
        "godog", "gogdo", "gogdo", "gogdo", "gogdo",
        "gogod", "gogod", "gogod", "gogod", "goodg",
        "goodg", "goodg", "goodg", "googd", "googd",
        "googd", "googd", "odggo", "odggo", "odggo",
        "odggo", "odgog", "odgog", "odgog", "odgog",
        "odogg", "odogg", "odogg", "odogg", "ogdgo",
        "ogdgo", "ogdgo", "ogdgo", "ogdog", "ogdog",
        "ogdog", "ogdog", "oggdo", "oggdo", "oggdo",
        "oggdo", "oggod", "oggod", "oggod", "oggod",
        "ogodg", "ogodg", "ogodg", "ogodg", "ogogd",
        "ogogd", "ogogd", "ogogd", "oodgg", "oodgg",
        "oodgg", "oodgg", "oogdg", "oogdg", "oogdg",
        "oogdg", "ooggd", "ooggd", "ooggd", "ooggd"
      ])
    end
    it 'returns the same values as the core lib function' do
      property_of {
        string
      }.check(100) {|string|
        expect(string.permutations).to match_array(string.chars.permutation.map(&:join))
      }
    end
  end
end
