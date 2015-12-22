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

class DashboardWithDefinedScopes
  ATTRIBUTE_TYPES = {
    name: Administrate::Field::String
  }

  COLLECTION_SCOPES = [:active]
end

describe Administrate::Search do
  describe "#scope" do
    let(:controller_path) { "admin/users" }
    let(:resource_resolver) do
      Administrate::ResourceResolver.new(controller_path)
    end
    let(:scope) { "active" }

    describe "the query is only the scope" do
      let(:query) { "#{scope}:" }

      it "returns nil if the model does not respond to the possible scope" do
        begin
          class User; end
          search = Administrate::Search.new(resolver, query)
          expect(search.scope).to eq(nil)
        ensure
          remove_constants :User
        end
      end

      it "returns the scope if the model responds to it" do
        begin
          class User
            def self.active; end
          end
          search = Administrate::Search.new(resolver, query)
          expect(search.scope).to eq(scope)
        ensure
          remove_constants :User
        end
<<<<<<< HEAD

        search = Administrate::Search.new(resource_resolver, query)
        expect(search.scope).to eq(scope)
      end

      it "returns nil if the name of the scope looks suspicious" do
        class User
          def self.destroy_all; end
        end

        Administrate::Search::BLACKLISTED_WORDS.each do |word|
          search = Administrate::Search.new(resource_resolver, "#{word}_all:")
          expect(search.scope).to eq(nil)
=======
      end

      it "returns nil if the name of the scope looks suspicious" do
        begin
          class User
            def self.destroy_all; end
          end

          Administrate::Search::BLACKLISTED_WORDS.each do |word|
            search = Administrate::Search.new(resolver, "#{word}_all:")
            expect(search.scope).to eq(nil)
          end
        ensure
          remove_constants :User
>>>>>>> Dashboard's COLLECTION_SCOPES for the index page (2/2)
        end
      end

      it "returns nil if the name of the scope ends with an exclamation mark" do
        begin
          class User
            def self.bang!; end
          end

<<<<<<< HEAD
        search = Administrate::Search.new(resource_resolver, "bang!:")
        expect(search.scope).to eq(nil)
=======
          search = Administrate::Search.new(resolver, "bang!:")
          expect(search.scope).to eq(nil)
        ensure
          remove_constants :User
        end
>>>>>>> Dashboard's COLLECTION_SCOPES for the index page (2/2)
      end

      describe "with COLLECTION_SCOPES defined" do
        let(:resolver) do
          double(resource_class: User, dashboard_class: DashboardWithDefinedScopes)
        end

        it "ignores the scope if it isn't included" do
          begin
            class User
              def self.closed; end
              def self.active; end
            end

            search = Administrate::Search.new(resolver, 'closed:')
            expect(search.scope).to eq(nil)
          ensure
            remove_constants :User
          end
        end

        it "returns the scope if it is included into COLLECION_SCOPES" do
          begin
            class User
              def self.closed; end
              def self.active; end
            end

            search = Administrate::Search.new(resolver, 'active:')
            expect(search.scope).to eq("active")
          ensure
            remove_constants :User
          end
        end
      end
    end

    describe "the query is the scope followed by the term" do
      let(:term) { "foobar" }
      let(:query) { "#{scope}: #{term}" }

      it "returns the scope and the term" do
        begin
          class User
            def self.active; end
          end

          search = Administrate::Search.new(resolver, query)
          expect(search.scope).to eq(scope)
          expect(search.term).to eq(term)
        ensure
          remove_constants :User
        end
<<<<<<< HEAD
        search = Administrate::Search.new(resource_resolver, query)
        expect(search.scope).to eq(scope)
        expect(search.term).to eq(term)
=======
>>>>>>> Dashboard's COLLECTION_SCOPES for the index page (2/2)
      end
    end
  end
end
