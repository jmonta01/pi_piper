require 'spec_helper'


describe 'Bcm2835' do
  
  before :context do
    Platform.driver
  end
  
  after :context do
    Bcm2835.exported_pins.delete_if { true }
  end

  # describe  'GPIO' do
    let(:file_like_object) { double("file like object") }

    before :example do
      allow(File).to receive(:read).and_return("1")
      allow(File).to receive(:write).and_return("1")
      allow(File).to receive(:open).and_return(file_like_object)
    end

    it 'should export a given pin & add it to the list' do
      expect(File).to receive(:write).with("/sys/class/gpio/export", 4)
      expect(Bcm2835.exported_pins.include?(4)).not_to be true
      Bcm2835.export(4)
      expect(Bcm2835.exported_pins.include?(4)).to be true
    end

    it 'should unexport a given pin & removed it from the list' do
      expect(File).to receive(:write).with("/sys/class/gpio/unexport", 4)

      Bcm2835.export(4)
      expect(Bcm2835.exported_pins.include?(4)).to be true
      Bcm2835.unexport_pin(4)
      expect(Bcm2835.exported_pins.include?(4)).not_to be true
    end
    
    it 'should unexport every exported pin' do
      Bcm2835.export(4)
      Bcm2835.export(18)
      Bcm2835.export(27)
      expect(Bcm2835.exported_pins).to eq [4,18,27]
      Bcm2835.unexport_all
      expect(Bcm2835.exported_pins).to eq []
    end

    it 'should tell if a pin is exported or not' do
      Bcm2835.export(4)
      expect(Bcm2835.exported?(4)).to be true
      expect(Bcm2835.exported?(112)).to be false
    end


    xit 'should unexport every pin at exit of the program' do
      pending 'Not yet very sure how to test that_exit hook !?'
      Bcm2835.export(18)
      Bcm2835.export(4)
    
      at_exit {
        expect(Bcm2835.exported_pins).to eq []
      }
    end
  # end

  # describe 'GPIO' do
    # before(:all) do
    #   Bcm2835.export(5)
    # end

    it 'should set pin\'s direction' do
      Bcm2835.export(5)
      expect(File).to receive(:write).with("/sys/class/gpio/gpio5/direction", "in")
      Bcm2835.pin_direction(5, 'in')
    end
    
    it 'should set pin as an input' do
      expect(Bcm2835).to receive(:export).with(4)
      expect(Bcm2835).to receive(:pin_direction).with(4, 'in')
      Bcm2835.pin_input(4)
    end
    
    it 'should set pin as an  output' do
      expect(Bcm2835).to receive(:export).with(4)
      expect(Bcm2835).to receive(:pin_direction).with(4, 'out')
      Bcm2835.pin_output(4)
    end

    it 'should set pin value' do
      Bcm2835.export(5)
      expect(File).to receive(:write).with("/sys/class/gpio/gpio5/value", 1)
      Bcm2835.pin_set(5, 1)
    end

    it 'should get pin value' do
      Bcm2835.export(5)
      expect(File).to receive(:read).with("/sys/class/gpio/gpio5/value")
      Bcm2835.pin_read(5)
    end

    it 'should stop RW access to pin after unexport' do
      Bcm2835.unexport_pin(4)
      expect { Bcm2835.pin_read(4) }.to         raise_error(PinError)
      expect { Bcm2835.pin_set(4, 1) }.to       raise_error(PinError)
      expect { Bcm2835.pin_direction(4, 1) }.to raise_error(PinError)
    end

    it 'should set pin edge' do
      Bcm2835.export(5)
      expect(File).to receive(:write).with("/sys/class/gpio/gpio5/edge", :both)
      Bcm2835.pin_set_edge(5, :both)
    end

    it 'should wait for an edge event to return' do
      pending 'how could we test edge trigger ?!'
      fail
    end

  # end

  xdescribe 'SPI' do
    it 'spidev_out(array)'
    it 'spi_transfer_bytes(data)'
  end
  
  xdescribe 'I2C' do
    it 'i2c_allowed_clocks'
    it 'i2c_transfer_bytes(data)'
    it 'i2c_read_bytes(bytes)'
  end
end

