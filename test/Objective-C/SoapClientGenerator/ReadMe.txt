Easy WSDL

http://easywsdl.com


How to use generated classes:

1. Add all files from src folder to your iOS project. We recommend to create a separate group for these files in your XCode project.
2. Add all files from KissXML folder to your project.
3. Go to the project settings (choose "Edit Project Settings" from "Project" menu").
4. Go to the "Build" tab and make the following changes:
    In the "Linking" section, go to the "Other Linker Flags" section and add the value "-lxml2" (without quotes).
    In the "Search Paths" section add a new search path to the "Header Search Paths" for "/usr/include/libxml2" (needed for KissXML library)


FGAAppChannelWebSvcServiceSoapBinding* service = [[FGAAppChannelWebSvcServiceSoapBinding alloc]init];
[service MethodToInvoke];


Used libraries:

- KissXML (https://github.com/robbiehanson/KissXML)

Thanks for using EasyWsdl. We've spend much time to create this tool. We hope that it will simplify your development. If you like it, please upvote posts about it on stackoverflow and like us on Facebook (https://www.facebook.com/EasyWsdl).
This will help us promote the generator. If you find any problems then contact us and we will try to help you with your webservice.


Generator output:
