require 'aws-sdk'
require 'rubygems'
require 'zip'

Aws.config.update({
credentials: Aws::Credentials.new('ID-KEY','SECRET')
})

#zip directory
directory = '/upload/'
$zipfile_name = 'upload.zip'

Zip::File.open($zipfile_name, Zip::File::CREATE) do |zipfile|
    Dir[File.join(directory, '*')].each do |file|
      zipfile.add(file.sub(directory, ''), file)
    end
end

#Cool little loading character spinner to show progress n stuff.
def loading_screen
  chars = %w[| / - \\]
  not_done = true
  loader = Thread.new do
    while not_done do  
      print chars.rotate!.first
      sleep 0.1
      print "\b"
    end
  end
  yield.tap do        
    not_done = false   
    loader.join       
  end                  
end

#upload to AWS S3 bucket
def upload
  ENV['AWS_REGION'] = 'us-east-2'

  s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
  obj = s3.bucket('ruby-upload-script').object($zipfile_name)

  obj.upload_file($zipfile_name)
end

loading_screen do 
  upload
end

puts "File Uploaded!"
