require 'spec_helper'

describe "ASSIGN rule" do

  let( :engine ) { Wongi::Engine.create }

  it "should assign simple expressions" do

    production = engine << rule {
      forall {
        assign :X do
          42
        end
      }
    }
    expect(production.size).to eq(1)
    expect(production.tokens.first[:X]).to eq(42)

  end

  it "should be able to access previous assignments" do

    production = engine << rule {
      forall {
        has 1, 2, :X
        assign :Y do |token|
          token[:X] * 2
        end
      }
    }

    engine << [1, 2, 5]
    expect(production.tokens.first[:Y]).to eq(10)

  end

  it 'should be deactivatable' do

    prod = engine << rule {
      forall {
        has 1, 2, :X
        assign :Y do |token|
          token[:X] * 2
        end
      }
    }

    engine << [1, 2, 5]
    engine.retract [1, 2, 5]

    expect( prod ).to have(0).tokens

  end

  it 'should be evaluated once' do
    x = 0
    prod = engine << rule {
      forall {
        has :a, :b, :c
        assign :T do
          x += 1
        end
      }
      make {
        gen :d, :e, :T
        gen :f, :g, :T
      }
    }
    engine << [:a, :b, :c]
    expect(x).to be == 1
  end

end
