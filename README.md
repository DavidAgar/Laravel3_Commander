Laravel 3 Commander
===================
####Note: A Laravel 4 version is available [Here](https://github.com/DavidAgar/Laravel4_Commander)

This is a batch script to help with laravel command line work on windows. 
Through the use of program launchers such a [Launchy](http://www.launchy.net/) and in combination with [Laravel-Generator](https://github.com/jeffreyway/laravel-generator) by [Jeffrey Way](https://twitter.com/jeffrey_way) shortcuts can be used to simplify a lot of common tasks.

Credit goes to [Ashley Clarke](https://github.com/clarkeash) who wrote the [Laravel-Alfred-Extension](https://github.com/clarkeash/Laravel-Alfred-Extension) which inspired the creation of a windows version.

This is my first foray into batch programming so please excuse any sloppy coding :)

###Requirements
[wget](http://users.ugent.be/~bpuype/wget/) : A copy of wget.exe is supplied but can be downloaded from link provided

[7-zip](http://www.7-zip.org/) : Needed to be installed to help during laravel installations.


###Installation
Download and place folder in a suitable location.
If needed add folder/files to your program launchers catalog.
You can then run commands by using

```laravel3 [command] [options]```

###Setup
On first use you will need to set your project base directory, This is the full path to the folder that your projects will be created in.

```laravel3 setup```

###Project
A new project can be created by using

```laravel3 install [folder_name]```  ie: ```laravel3 install l3```

This will then download the latest version of Laravel 3 from Github and move all files into the chosen folder.<br>
application.php will then be downloaded and moved to the correct place.
Finally ```artisan key:generate``` will be executed to set up your secure key.

From here any commands run will be executed on this working project.
At any time you can change the working project by running

```laravel3 project [folder_name]``` or use the shortcut ```laravel3 p [folder_name]```
###General Commands
```laravel3 info``` This will show all your current settings including the working project.<br>
```laravel3 help``` This will bring up the help screen.<br>
```laravel3 artisan [command]``` Run any artisan command on the working project.<br>
***
As we are focused on the [Laravel-Generator](https://github.com/jeffreyway/laravel-generator) you will need to acquaint yourself with its command structure to get the best out of the following available commands.
###Commands
```laravel3 controller [controllername] [methods/actions]``` or ```laravel3 c [controllername] [methods/actions]```<br>
```laravel3 model [modelname]``` or ```laravel3 m [modelname]```<br>
```laravel3 view [viewname/s]``` or ```laravel3 v [viewname/s]```<br>
```laravel3 migration [command] [schema]``` or ```laravel3 mig [command] [schema]```<br>
```laravel3 migrate```<br>
```laravel3 rollback```<br>
```laravel3 resource [commands]``` or ```laravel3 r [commands]```<br>
```laravel3 assets [items]``` or ```laravel3 a [items]```<br>
```laravel3 test [name]```
 
###Examples
Create a model<br>
```laravel3 m Post```

migration<br>
```laravel3 mig create_users_table id:integer name:string email_address:string```

Resource<br>
```laravel3 r post index show```
***
##Launchy
To help you get this setup in [Launchy](http://www.launchy.net/) hit ALT+SPACE to bring up its window and click on the options icon (top right). On the Catalog tab you will need to add the laravel commander folder to the Directories and \*.\* to the File Types area. Once done hit Rescan Catalog and ok out.

![Launchy Options](https://dl.dropboxusercontent.com/s/gqhgevdncdt1d4s/launchy1ss.png "Launchy Options")

From here on all commands can be accessed like the following<br>
ALT+SPACE type laravel3 [TAB] install l3

![Launchy Run Command](https://dl.dropboxusercontent.com/s/rnsmhb12faj1tl0/launchy2ss.png "Launchy Run Command")
 