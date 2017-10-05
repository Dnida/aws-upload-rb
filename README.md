# aws-upload-rb
A simple ruby script that compresses a directory and uploads it to an s3 bucket. I use this script with an aggressive s3 lifecycle to upload files to glacier after 5 days.


This script requires the aws-sdk gem, and also rubyzip.
