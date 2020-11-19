# CLI CRUD Utility Example 
## CLI utility for showing capability of Absio swift SDK

Requirements for build: 
macOS 10.14+
XCode 11.7 + 

1. Install pods with ```pod install ```
4. open *.xcworkspace
5. run solution

CLI tool works with several providers, default one is server provider.

WorkFlow: 
Before login: 
- register new user
- provider selecting option: there is three different providers available: server, ofs and mixed

Creating container: 
1. Define a type: 
        - 'File' - data from file will be stored as a container content, file name will be store in header as a string
        - 'Data' - container content and header represented as string
        - empty - content will be empty, header could be defined as string.

2. Add access for user: 
        - added access modifiers fo given user. Flags should be separated with spaces.
        For example: downloadContainer decryptContainer uploadContainer viewAccess nviewContainerType


Update container: is quite similar to create, except there is possibility to change only access modifiers(for already existing user or for new one). List of existing users will be printed after choosing appropriate menu.
    
Managing users: delete user or change credentials.
Events: after selecting menu option 'Get Event', cli will print all event related to current user.

Get container: 
- after passing container id cli will print out metadata for this container and access levels for all users which have access to it.
- if container type is 'File' - cli will ask to store file locally into Documents folder and open or not.
- if container type is 'Data' or empty, string values will be printed 