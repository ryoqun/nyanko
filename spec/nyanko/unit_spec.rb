require "spec_helper"

module Nyanko
  describe Unit do
    let(:unit) do
      Module.new { include Nyanko::Unit }
    end

    let(:view) do
      Class.new { include Nyanko::Helper }.new
    end

    describe ".active_if" do
      before do
        ActiveIf.define(:true) { true }
        ActiveIf.define(:false) { false }
      end

      after do
        ActiveIf.clear
      end

      subject { unit.active?(view) }

      context "when labels are specified" do
        before do
          unit.active_if(:true, :false)
        end
        specify "all of defined conditions must pass" do
          should be_false
        end
      end

      context "when block is passed" do
        before do
          unit.active_if(:true) { false }
        end
        specify "all of defined conditions and block must pass" do
          should be_false
        end
      end

      context "when any is specified" do
        before do
          unit.instance_eval do
            active_if any(:true, :false)
          end
        end
        specify "any of conditions must pass" do
          should be_true
        end
      end
    end

    describe ".scope" do
      specify "given scope is recorded to used scope list" do
        unit.scope(:view) { }
        unit.scopes.keys.should == [ActionView::Base]
      end

      context "in the scoped block" do
        specify "current_scope returns given scope" do
          unit.scope(:view) do
            unit.current_scope.should == ActionView::Base
          end
        end
      end

      context "out of the scoped block" do
        specify "current_scope returns nil" do
          unit.scope(:view) { }
          unit.current_scope.should == nil
        end
      end
    end

    describe ".function" do
      it "stores given block with current_scope and given label" do
        unit.scope(:view) do
          unit.function(:test) do
            "test"
          end
        end
        unit.scopes[ActionView::Base][:test].block.should === "test"
      end
    end

    describe ".shared" do
      it "stroes given block with given label" do
        unit.shared(:test) do
          "test"
        end
        unit.shared_methods[:test].call.should == "test"
      end
    end

    describe ".helpers" do
      before do
        unit.stub(:name => "ExampleUnit")
      end

      it "provides interface for unit to define helper methods" do
        unit.helpers do
          def test
            "test"
          end
        end
        view.__example_unit_test.should == "test"
      end
    end
  end
end