require 'spec_helper'
require 'string_permutations_iterative'

# for checking test cases easily
# http://users.telenet.be/vdmoortel/dirk/Maths/permutations.html

describe String do
  describe "#permutations" do
    it 'returns all permutations of a string' do
      expect('ABC'.permutations).to match_array(%w{ ABC ACB BAC BCA CBA CAB })
    end
    it 'works for any size of string' do
      expect('abcd'.permutations).to match_array(%w{ abcd abdc acbd acdb adbc adcb bacd badc bcad bcda bdac bdca cabd cadb cbad cbda cdab cdba dabc dacb dbac dbca dcab dcba })
      expect('doggo'.permutations).to match_array(%w{ doogg dogog doggo dgoog dgogo dggoo odogg odgog odggo oodgg oogdg ooggd ogdog ogdgo ogodg ogogd oggdo oggod gdoog gdogo gdgoo godog godgo goodg googd gogdo gogod ggdoo ggodo ggood })
    end
  end
end
