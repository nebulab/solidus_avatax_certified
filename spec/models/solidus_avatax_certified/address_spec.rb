require 'spec_helper'

describe SolidusAvataxCertified::Address, :type => :model do
  let(:country){ FactoryGirl.create(:country) }
  let(:address){ FactoryGirl.create(:address, city: 'Tuscaloosa', address1: '220 Paul W Bryant Dr') }
  let(:order) { FactoryGirl.create(:order_with_line_items, ship_address: address) }

  before do
    Spree::AvalaraPreference.address_validation.update_attributes(value: 'true')
  end

  let(:address_lines) { SolidusAvataxCertified::Address.new(order) }

  describe '#initialize' do
    it 'should have order' do
      expect(address_lines.order).to eq(order)
    end
    it 'should have addresses be an array' do
      expect(address_lines.addresses).to be_kind_of(Array)
    end
  end

  describe '#build_addresses' do
    it 'receives origin_address' do
        expect(address_lines).to receive(:origin_address)
        address_lines.build_addresses
    end
    it 'receives order_ship_address' do
        expect(address_lines).to receive(:order_ship_address)
        address_lines.build_addresses
    end
    it 'receives origin_ship_addresses' do
        expect(address_lines).to receive(:origin_ship_addresses)
        address_lines.build_addresses
    end
  end

  describe '#origin_address' do
    it 'returns an array' do
      expect(address_lines.origin_address).to be_kind_of(Array)
    end

    it 'has the origin address return a hash' do
      expect(address_lines.origin_address[0]).to be_kind_of(Hash)
    end
  end

  describe '#order_ship_address' do
    it 'returns an array' do
      expect(address_lines.order_ship_address).to be_kind_of(Array)
    end

    it 'has the origin address return a hash' do
      expect(address_lines.order_ship_address[0]).to be_kind_of(Hash)
    end
  end

  describe "#validate" do
    it "validates address with success" do
      result = address_lines.validate
      expect(address_lines.validate["ResultCode"]).to eq("Success")
    end

    it "does not validate when config settings are false" do
      Spree::AvalaraPreference.address_validation.update_attributes(value: 'false')
      result = address_lines.validate
      expect(address_lines.validate).to eq("Address validation disabled")
    end

    it 'fails when information is incorrect' do
      order.ship_address.update_attributes(city: nil)

      expect(address_lines.validate['ResultCode']).to eq('Error')
    end
  end
end
