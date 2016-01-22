require "active_support/core_ext/module"
require "administrate/page/collection"

describe Administrate::Page::Collection do
  # #scope_groups creates the concept of "group of scopes" to manage scopes
  # always grouped reading Dashboard#collection_scopes (COLLECTION_SCOPES).
  describe "#scope_groups" do
    let(:scope) { :mellow }
    let(:array_of_scopes) { [ scope ] }
    let(:hash_of_scopes) do
      {
        symbol_key: [ :active, :inactive, 'active_since(1992)' ],
        'string_key': [ 'funny', :sad ]
      }
    end

    describe "with no scopes defined" do
      let(:dashboard) { double(collection_scopes: []) }

      it "returns an empty array" do
        page = Administrate::Page::Collection.new(dashboard, nil)
        expect(page.scope_groups).to eq([])
      end
    end

    describe "with an Array of scopes" do
      let(:dashboard) { double(collection_scopes: array_of_scopes) }

      it "returns an array with the :scopes symbol inside ([:scopes])" do
        page = Administrate::Page::Collection.new(dashboard, nil)
        expect(page.scope_groups).to eq([:scopes])
      end
    end

    describe "with a Hash grouping the scopes" do
      let(:dashboard) { double(collection_scopes: hash_of_scopes) }

      it "returns the hash's keys" do
        page = Administrate::Page::Collection.new(dashboard, nil)
        expect(page.scope_groups).to eq(hash_of_scopes.keys)
      end
    end
  end

  # #scope_names([group]) returns an array with *scope names*. A *scope name*
  # can be a symbol or a string that matchs with an scope defined in the
  # dashboard's model including the scope's argument when needed (e.g.
  # ["valid", "awesome_since(2004)"]).
  describe "#scope_names([group])" do
    let(:scope_symbol) { :mellow }
    let(:array_of_symbols) { [ scope_symbol ] }
    let(:scope_string) { 'immature' }
    let(:array_of_strings) { [ scope_string ] }
    let(:hash) do
      {
        symbol_key: [ :active, :inactive, 'active_since(1992)' ],
        'string_key': [ 'funny', :sad ]
      }
    end

    describe "with no scopes defined" do
      let(:dashboard) { double(collection_scopes: []) }

      it "returns an empty array (and ignores group passed as argument)" do
        page = Administrate::Page::Collection.new(dashboard, nil)
        expect(page.scope_names).to eq([])
        expect(page.scope_names(:scopes)).to eq([])
      end
    end

    describe "with an Array of scope strings" do
      let(:dashboard) { double(collection_scopes: array_of_strings) }

      it "returns that array (and ignores group passed as argument)" do
        page = Administrate::Page::Collection.new(dashboard, nil)
        expect(page.scope_names).to eq(array_of_strings)
        expect(page.scope_names(:scopes)).to eq(array_of_strings)
      end
    end

    describe "with an Array of scope symbols" do
      let(:dashboard) { double(collection_scopes: array_of_symbols) }

      it "returns that array stringified" do
        page = Administrate::Page::Collection.new(dashboard, nil)
        expect(page.scope_names).to eq(array_of_symbols.map(&:to_s))
      end
    end

    describe "with a Hash grouping the scopes" do
      let(:dashboard) { double(collection_scopes: hash) }

      it "returns the stringified scopes of the group passed as param" do
        page = Administrate::Page::Collection.new(dashboard, nil)
        expect(page.scope_names(:symbol_key)).to eq(hash[:symbol_key].map(&:to_s))
      end
    end
  end
end
