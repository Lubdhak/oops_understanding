require_relative 'admin_tasks'
include AdminTasks

#::AdminTasks.addVendor
Vendor.addVendor
Vendor.call_upload
Vendor.uploadfile_s3