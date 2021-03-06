require 'test_helper'

class ReadonlyAttributesTest < MiniTest::Spec
  Location = Struct.new(:country)

  class LocationForm < Reform::Form
    property :country, virtual: true # read_only: true
  end

  let (:loc) { Location.new("Australia") }
  let (:form) { LocationForm.new(loc) }

  it { form.country.must_equal "Australia" }
  it do
    form.validate("country" => "Germany") # this usually won't change when submitting.
    form.country.must_equal "Germany"

    form.sync
    loc.country.must_equal "Australia" # the writer wasn't called.

    hash = {}
    form.save do |nested|
      hash = nested
    end

    hash.must_equal("country"=> "Germany")
  end
end
