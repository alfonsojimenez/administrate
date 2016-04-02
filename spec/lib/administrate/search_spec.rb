require "support/constant_helpers"
require "active_support/core_ext/module"
require "administrate/search"
require "administrate/resource_resolver"

class MockDashboard
  ATTRIBUTE_TYPES = {
    name: Administrate::Field::String,
    email: Administrate::Field::Email,
    phone: Administrate::Field::Number,
  }
end

describe Administrate::Search do
  describe "#scope" do
    let(:controller_path) { "admin/users" }
    let(:resource_resolver) do
      Administrate::ResourceResolver.new(controller_path)
    end
    let(:scope) { "active" }
    let(:query) { "#{scope}:" }

    it "give us the search scope" do
      begin
        class User
          def self.active; end
        end
        search = Administrate::Search.new(resource_resolver, query)
        expect(search.scope).to eq(scope)
      ensure
        remove_constants :User
      end
    end

    it "returns nil if the name of the scope looks suspicious" do
      begin
        class User
          class << self
            def destroy_all; end
          end
        end

        Administrate::Search::BLACKLISTED_WORDS.each do |word|
          search = Administrate::Search.new(resource_resolver, "#{word}_all:")
          expect(search.scope).to eq(nil)
        end
      ensure
        remove_constants :User
      end
    end

    it "returns nil if the name of the scope ends with an exclamation mark" do
      begin
        class User
          class << self
            def bang!; end
          end
        end

        search = Administrate::Search.new(resource_resolver, "bang!:")
        expect(search.scope).to eq(nil)
      ensure
        remove_constants :User
      end
    end
  end
end
