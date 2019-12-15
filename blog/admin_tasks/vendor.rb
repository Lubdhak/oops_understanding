module AdminTasks
  class Vendor
    def self.addVendor
      primate(myumethod)
    end

    def self.call_upload
      uploadfile_s3(1,2)
    end

    private
    def self.primate(x)
      puts "this is #{x}"
    end
  end
end