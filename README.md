# 1pass2keepassx

[KeePassX](http://www.keepassx.org/ "The Official KeePassX Homepage") is a rebuild of the KeePass application for Linux.  It has a cleaner UI than some of the other applications I have used in the past, but one drawback with this implementation is that it does not support importing from CSV files.  This poses a bit of an issue when many other clients only offer CSV for exporting the information.

To get around this limitation, this script will convert a CSV export from several sources to a KeePass-compatible XML file.

## Supported _(in theory)_ Export Clients

* Password Gorilla
* 1pass _(not tested by me)_
* firefox password export _(not tested by me)_

## Requirements

* Ruby 1.9 or greater
* A CSV export containing your passwords
* Some minimal knowledge of the command line, _(but you're running Linux anyway, right ;) )_

## Usage

**As with any security-oriented application**, open the source code of this script and exam it for any vulnerabilities or weird things!  You're dealing with an archive of your passwords in unencrypted form, as such you can never be too careful.

After you checkout the file, make sure it's executable.  You can do this by right-clicking on the 1pss2keepass.rb file, selecting properties -> Permissions tab, and checking 'Allow executing file as program' or by executing `chmod a+x 1pass2keepass.rb` in the CLI.

Open terminal and `cd` to the directory containing 1pass2keepass.rb file

    ./1pass2keepass.rb /path/to/my/passwords/export.csv > export.xml

Then, open KeePassX, select File -> Import From... -> KeePassX XML and choose your file.

## Cleanup

After you've imported your data into a new encrypted database inside of KeePassX's clean UI, you want to delete the unencrypted data.  **Scratch that**, you want to tin-foil-hat-securely delete your unenencrypted data.

    shred -u /path/to/my/passwords/export.csv
    shred -u export.xml

Will overwrite the files with random bits of 0's and 1's several times over, and then mark the file for deletion on the disk.

### Why recommend overwriting the file?  Isn't deleting it good enough?

Deleting a file will mark the sectors used by that file as "free" in the inode, (or FAT), table, but the actual data still exists on the disk in plain text and very easilly recoverable.  By writing random data to the sectors first, the data is completely eradicated before marking the sectors as free.