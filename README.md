Docker based CouchDB cartridge for apache Startos

What is CouchDB?

CouchDB is a database that completely embraces the web. Store your data with JSON documents. Access your documents and query your indexes with your web browser, via HTTP. Index, combine, and transform your documents with JavaScript. CouchDB works well with modern web and mobile apps. You can even serve web apps directly out of CouchDB. And you can distribute your data, or your apps, efficiently using CouchDB’s incremental replication. CouchDB supports master-master setups with automatic conflict detection.
CouchDB comes with a suite of features, such as on-the-fly document transformation and real-time change notifications, that makes web app development a breeze. It even comes with an easy to use web administration console. You guessed it, served up directly out of CouchDB! We care a lot about distributed scaling. CouchDB is highly available and partition tolerant, but is also eventually consistent. And we care a lot about your data. CouchDB has a fault-tolerant storage engine that puts the safety of your data first.

How it works?

A CouchDB server hosts named databases, which store **documents**. Each document is uniquely named in the database, and CouchDB provides a RESTful HTTP API for reading and updating (add, edit, delete) database documents.
Documents are the primary unit of data in CouchDB and consist of any number of fields and attachments. Documents also include metadata that’s maintained by the database system. Document fields are uniquely named and contain values of varying types (text, number, boolean, lists, etc), and there is no set limit to text size or element count.
The CouchDB document update model is lockless and optimistic. Document edits are made by client applications loading documents, applying changes, and saving them back to the database. If another client editing the same document saves their changes first, the client gets an edit conflict error on save. To resolve the update conflict, the latest document version can be opened, the edits reapplied and the update tried again.
Document updates (add, edit, delete) are all or nothing, either succeeding entirely or failing completely. The database never contains partially saved or edited documents.



Comparison between mongoDB

MongodB : Consistency and Partition Tolerance

CouchDB : Availability and Partition Tolerance

A blog post, Cassandra vs MongoDB vs CouchDB vs Redis vs Riak vs HBase vs Membase vs Neo4j comparison has 'Best used' scenarios for each NoSQL database compared. Quoting the link,

MongoDB: If you need dynamic queries. If you prefer to define indexes, not map/reduce functions. If you need good performance on a big DB. If you wanted CouchDB, but your data changes too much, filling up disks.

CouchDB : For accumulating, occasionally changing data, on which pre-defined queries are to be run. Places where versioning is important.

A recent (Feb 2012) and more comprehensive comparison by Riyad Kalla,

MongoDB : Master-Slave Replication ONLY

CouchDB : Master-Master Replication


Design architecture of the Openstack with Docker configuration
 

Openstack with Docker work as the underlying IaaS. Apache Stratos work as the PaaS environment that works with IaaS. On top of this stack, fully-configured cartridge images for which CouchDB and PHP will be deployed for demonstration purposes. 

Design architecture of the CouchDB cartridge (Content of the docker container)



