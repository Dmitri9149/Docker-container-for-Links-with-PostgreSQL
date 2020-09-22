### Dockerize Links language learning environment (with PostgreSQL) 

The Links language  has many advanced features. 
It is possible to make web development from within one language with very dense code, computation with effects and there is support of asynchronous session types. The Links is potentially very attractive for applications in AI. The big part of 
AI is about the communication of many agents and is to be abstracted (as much as possible) from the 
specific details of  web , networks, JavasSript, Java, HTML etc. Links development is in the direction. 

#### The short description of the Links from the language developers (see from https://github.com/links-lang/links)

------------------------------------
Links helps to build modern Ajax-style applications: those with significant client- and server-side components.

A typical, modern web program involves many "tiers": part of the program runs in the web browser, part runs on a web server, and part runs in specialized systems such as a relational database. To create such a program, the programmer must master a myriad of languages: the logic is written in a mixture of Java, Python, and Perl; the presentation in HTML; the GUI behavior in Javascript; and the queries are written in SQL or XQuery. There is no easy way to link these: to be sure, for example, that an HTML form or an SQL query produces the type of data that the Java code expects. This is called the impedance mismatch problem.

Links eases the impedance mismatch problem by providing a single language for all three tiers. The system is responsible for translating the code into suitable languages for each tier: for instance, translating some code into Javascript for the browser, some into Java for the server, and some into SQL to use the database.

Links incorporates ideas proven in other programming languages: database-query support from Kleisli, web-interaction proposals from PLT Scheme, and distributed-computing support from Erlang. On top of this, it adds some new web-centric features of its own.

FEATURES

    Allows web programs to be written in a single programming language
    Call-by-value functional language
    Server / Client annotations
    AJAX
    Scalability through defunctionalised server continuations.
    Statically typed database access a la Kleisli
    Concurrent processes on the client and the server
    Statically typed Erlang-esque message passing
    Polymorphic records and variants
    An effect system for supporting abstraction over database queries whilst guaranteeing that they can be efficiently compiled to SQL
    Handlers for algebraic effects on the server-side and the client-side
-----------------------------------------------

It is not very easy to install the language with full environment. It is installed on the top of OCaml environment + some database installation.   
Details are spreaded : https://github.com/links-lang/links/wiki/Database-setup ; 
https://github.com/links-lang/links/blob/master/INSTALL.md ; https://github.com/links-lang/links-tutorial

In the https://github.com/links-lang/links-tutorial it is recommended to install the Links to VirtualBox 
(with Vagrant to automate the process).

Here we make Docker environment for Links. It is good to visit the above mentioned referencies and the language manual : https://links-lang.org/quick-help.html

See also comments in the Dockerfile.

We start FROM  opam/ocaml2 https://hub.docker.com/r/ocaml/opam2/ and add needed packages. 

Using postgres credential we make new database with name 'links' and move all the credentials to 'opam' user. 

THE PASSWORD IS HARD CODED IN THE Dockerfile. IT WILL BE BETTER IF YOU REBUILD THE IMAGE FROM 
Dockerfile CHANGING TO YOUR PASSWORD IN THE CODE OF Dockerfile (IN 2 PLACES). THE PASSWORD IN SAVED IN config FILE IN links_folder.

The environment is for the learning, not for a production. 

Within container you may do :  
$linx
to start the interactive session within container.     
With  
$linx --config=config   
you may start interactive session within container and test the database created. See the session below. 

```
opam@4a6f01f282e5:~/opam-repository/links_examples$ linx --config=config
 _     _ __   _ _  __  ___
/ |   | |  \ | | |/ / / ._\
| |   | | , \| |   /  \  \
| |___| | |\ \ | |\ \ _\  \
|_____|_|_| \__|_| \_|____/
Welcome to Links version 0.9.1 (Burghmuirhead)
links> var db = database "links";
db = (database postgresql:links:localhost:5432:opam:password : Database
links> var test = table "test" with (i : Int, s : String) from db;
test = (table test) : TableHandle((i:Int,s:String),(i:Int,s:String),(i:Int,s:String))
links> insert test  values (i, s) [(i=1, s="one")];
() : ()
links> query {for (x <-- test) [x]};
[(i = 1, s = "one")] : [(|i:Int,s:String)]
links> 
opam@4a6f01f282e5:~/opam-repository/links_examples$ 
```
Executing the  script within container: 
 
$./web_examples 

tutorial Links web examples (without database) will be awailable on your specified localhost port 
(we expect you run the container with something like   
$docker run -it -p 8080:8080 image_name  
from your nachine).   

The full set of examples is awaiable at Links language official web page : https://links-lang.org/
(Demo programms).

Below is the script (see https://github.com/links-lang/links/wiki/Database-setup ) 

-------------------------------
```
#!/bin/bash

linx --path=$OPAM_SWITCH_PREFIX/share/links/examples \
     --path=$OPAM_SWITCH_PREFIX/share/links/examples/games \
            $OPAM_SWITCH_PREFIX/share/links/examples/webserver/examples-nodb.links

```
---------------------------------------

As an example of using the environment, from the project folder we did:  
$mkdir links_examples   
$touch links_examples/todo.links

And we add the code from the Links tutorial : https://github.com/links-lang/links-tutorial/blob/master/4_todo/todo.links  
to local links_examples/todo.links file.  
See the code (quite dense, about 40 lines only, front end + server)  

```
fun remove(item, items) {
  switch (items) {
     case []    -> []
     case x::xs -> if (item == x) xs
                   else x::remove(item, xs)
  }
}


fun todo(items) {
   <html>
    <body>
     <form l:onsubmit="{replaceDocument(todo(item::items))}">
       <input l:name="item"/>
       <button type="submit">Add item</button>
     </form>
     <table>
      {for (item <- items)
        <tr><td>{stringToXml(item)}</td>
            <td><form l:onsubmit="{replaceDocument(todo(remove(item,items)))}">
                 <button type="submit">Completed</button>
                </form>
            </td>
        </tr>}
      </table>
     </body>
   </html>
}

fun mainPage(_) {
  page
   <#>{todo(["add items to todo list"])}</#>}

fun main () {
 addRoute("",mainPage);
 servePages()
}

main()

```
From your machine run something like: 
```
dmitri@dmitri-Aspire-A314-32:~/docker_linx$ sudo docker run -v $(pwd)/links_examples:/links_examples  -it -p 8080:8080 docker_links  

and you will see the reply from the container:   

 * Restarting PostgreSQL 10 database server                                                             [ OK ]
```

And from within running container : 
```
opam@98da55efced9:~/opam-repository/links_folder$ linx /links_examples/todo.links

```

The todo app will start at localhost:8080 on local machine


You may pull the image with : 
