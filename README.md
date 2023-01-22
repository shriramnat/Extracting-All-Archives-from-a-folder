# Extracting All zip files within a folder
As a Graphic Designer and an Video Editor, I have this problem frequently. 
- I download a lot of files and supporting graphics from different sources
- I download a lot of fonts for different projects 

All of these get downloaded as individual zip files and there are sometimes so many of them. I have to then manually extract these zips before I can get access to the actual content.

This utility will help unzip all the zip files within a Directory in one go. It is basically a glorified use of the `Extract-Archive` cmdlet. 
You can optionally specify a Destination folder. If you dont, it will just unzip all the archives within the source and will create a separate folder per zip file.
