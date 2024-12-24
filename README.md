Shell-ShellNS-Output
================================

> [Aeon Digital](http://www.aeondigital.com.br)  
> rianna@aeondigital.com.br

&nbsp;

``ShellNS Output`` unifies the functions of ``ShellNS Dialog`` and 
``ShellNS Result`` to simplify the use of both simultaneously.  


&nbsp;
&nbsp;

________________________________________________________________________________

## Main

After downloading the repo project, go to its root directory and use one of the 
commands below

``` shell
# Loads the project in the context of the Shell.
# This will download all dependencies if necessary. 
. main.sh "run"



# Installs dependencies (this does not activate them).
. main.sh install

# Update dependencies
. main.sh update

# Removes dependencies
. main.sh uninstall




# Runs unit tests, if they exist.
. main.sh utest

# Runs the unit tests and stops them on the first failure that occurs.
. main.sh utest 1



# Export a new 'package.sh' file for use by the project in standalone mode
. main.sh export


# Exports a new 'package.sh'
# Export the manual files.
# Export the 'ns.sh' file.
. main.sh extract-all
```

&nbsp;
&nbsp;


________________________________________________________________________________

## Standalone

To run the project in standalone mode without having to download the repository 
follow the guidelines below:  

``` shell
# Download with CURL
curl -o "shellns_output_standalone.sh" \
"https://raw.githubusercontent.com/AeonDigital/Shell-ShellNS-Output/refs/heads/main/standalone/package.sh"

# Give execution permissions
chmod +x "shellns_output_standalone.sh"

# Load
. "shellns_output_standalone.sh"
```


&nbsp;
&nbsp;


________________________________________________________________________________

## How to use

### Set and shows Dialog and Results

``` shell
# Set with error and no values
strMessage="An unexpected error has occurred.  \n";
strMessage+="Check the **write permissions** in the chosen directory.";
shellNS_output_set "fnName" "1" "" --dialog "error" "${strMessage}"

# Outputs
shellNS_output_show
[ err ] An unexpected error has occurred.
        Check the write permissions in the chosen directory.
echo $?
1


# Set with success and 3 values
strMessage="The operation was **successful**."
shellNS_output_set "fnName" "0" "v1" "v2" "v3" --dialog "ok" "${strMessage}"


# Atention
# The 'show' function will always return only 1 index value indicated.
# Along with the value, it will show the linked dialog message if it exists.
# After printing the data, all stored values will be lost, unless you use the 
# $2 parameter to change this behavior.

# Shows the first value and keeps the others for later reference. 
shellNS_output_show 0 1
v1

[  v  ] The operation was successful.


# Shows the first value while keeping the others in the registry but omits the 
# dialog message.
shellNS_output_show 0 1 1
v1


# Shows the second value
shellNS_output_show 1 1
v2

[  v  ] The operation was successful.


# Shows the third value and allows the saved data to be deleted. 
shellNS_output_show 2
v3

[  v  ] The operation was successful.
```

&nbsp;
&nbsp;


________________________________________________________________________________

## Licence

This project uses the [MIT License](LICENCE.md).