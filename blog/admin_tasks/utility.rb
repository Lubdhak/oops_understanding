module AdminTasks
        def myumethod
            puts "utility.rb"
            #a = gets.chomp
            #puts a
        end

        private
        
        def getfile_s3(jira_ticket_id,remote_file_name,env)
            # what if file don't exists in s3 ?
            s3_service = ::Aws::S3::Client.new(region: "us-east-1")
            if env == 'p'
                env = AppConstant::AdminTasks.environments[1]
            else
                env = AppConstant::AdminTasks.environments[0]
            end

            s3_key = "#{env}/#{jira_ticket_id}/#{remote_file_name}"
            params = {
                bucket: AppConstant::AdminTasks.bucket,
                s3_key: s3_key
            }
            local_file_path = "./log/#{File.basename(s3_key)}"
            report_file = s3_service.get_object(params,target: local_file_path)
            puts "File saved to #{local_file_path}"
            data = csv_parser(local_file_path)
            File.delete(local_file_path)
            return data
        end

        def uploadfile_s3(jira_ticket_id,local_file_path)
          puts 'uplad s3'
          return true
            # what if file already exists in s3 ?
            puts local_file_path
            AppConstant::AdminTasks.environments.each do |env|
                params = {
                    s3_path: "#{env}/#{jira_ticket_id}",
                    file_path: local_file_path,
                    bucket: AppConstant::AdminTasks.bucket,
                    delete_local_file: false
                }
                response = Util::S3FileUploadService.new(params).upload
                if response.etag.present?
                    puts "Successfully uploaded #{params[:file_path]} to #{params[:s3_path]}"
                else
                    puts "Upload Failed for #{params[:file_path]} to #{params[:s3_path]}" 
                end
            end
        end

        def csv_parser(filepath)
            require 'csv'
            x = File.read(filepath).scrub
            params = {:headers => true,:header_converters => :symbol,:converters => [:all]}
            y = CSV.new(x,params).to_a
            y.map {|row| row.to_hash }
        end
end


