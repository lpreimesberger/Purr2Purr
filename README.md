# purr2purr

Purr2Purr is a framework to allow peer to peer networking and message in environments where Internet
is not available or is restricted by outside forces.   It is intended for Burning Man and other
similar festivals - but can be used anywhere and all code is MIT licensed.

Purr2Purr has been around several years - but recent hardware updates make it easier for people to
use and extend.  CAT Camp is releasing this code to help spur adoption.

This application is both a basic utility with enough functionality to encourage people to use 
Purr2Purr.  We provide a Playa Schedule app from the Borg data, and internal messaging.

Through implementing open or hidden Purr2Purr relays - messages and other data can be passed over
the network securely.  Data can be relayed over the main exchange box we host on the internet.

## Purr2Purr PKI

tldr; - to start your own fork you need a key infrastructure.  
For the base network - request a key in the Github issues to add your node in.

Each network has a unique secret key that glues everything together, when that key is lost or 
expires the network will stop working until it is renewed.  To join your access point or app - 
you need to request a key.  There are Python scripts under /keys for this in the server repo.  
Run the script, and add the request (*NOT THE KEY FILES*) to the
Github request.  We will return a certificate you need to add to your install.

When the client connects to another node - the link occurs over https - which uses the secret key 
as well as the issued certificate.  We misuse the SAN fields in the certificate in this version to
list allowed services for the node (there are 'better' fields - but many libraries do not support them).

## how it works

To prevent central control - apps and waypoints work off trust lists.

When you load Purr2Purr on your phone - it will create a FIPS 186-3 ECDSA key on your phone in the 
application data store.  This is your identity on the network - if you uninstall the app the keys are
lost and all data is 'shredded'.  It will also create a random Burner name - if you need to by known - we
recommend you change this to your Burner name, preferably appending your camp name because there are a 
lot of duplicates out there (i.e. - reptar@catcamp).

The actual identity of your phone is a packed Bitcoin-style address based on your credentials,  it is not
a valid address on any crypto network.  It's a string starting with v0 that represents you until you
reset everything.

Any Purr2Purr node you connect to needs to have a valid certificate for the network.  This is to prevent
run away spam attacks on playa.  Each 'protocol' in Purr2Purr also has a defined JSON schema expressed
in POGO in the Purr2Purr Wiki.

There is no central directory - to message people you need to 'accept' the link through exchanging 
keys to prevent spam through QR swaps.  There is also the concept of 'mailing lists' where one can 
blast information to many (i.e. - camp leads sending updates to campers).

Registered applications are those whose public keys are recognized by the access points.  Currently - these are only:

- the Purr2Purr App - including messaging
- Playa Pong - a CAT Camp 2023 proposed art work

Most mobile apps are poorly secured at best - expect your key to 'leak' almost immediately - especially
if releasing a Java-based app.  For the event though - this is 'good enough'.   The level of skill to
get and use your key is high enough it's unlikely anyone will try for a week.


## WHO ARE YOU PEOPLE!

CAT Camp is a nonprofit that runs our Playa presence, brings art work and supplies for 
humans to the playa.  You will never find a more wretched hive of scum and villainy. 

