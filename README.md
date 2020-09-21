### Dockerize Links language

This is attempt to make Docker learning environment for Links 
functional programming language. 

The language is very interesting and has many advanced features. 
I am especially interested in the web development from within one language 
(see the examples, when full stack application can be done from within one short file !) , 
computation with effects and in the support of asynchronous session types and multiagent 
communication. The Links is potentially very attractive for applications in AI. The big part of 
AI is about the communication of many agents and is to be abstracted (as much as possible) from the 
specific details of  web , networks, JavasSript, Java, HTML etc. 
The level of Links abstraction is quite high. For example HTML forms and data bases are first class 
citizens. See the short description of the LInks from the language developers.   

# from https://github.com/links-lang/links 

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
################################################################################

But it happens to be not an easy exercise to install the language environment. Firstly it is need to 
install opam environment for Ocaml, then install a data base (posrgresql in our case).  
Details are spreaded : https://github.com/links-lang/links/wiki/Database-setup ; 
https://github.com/links-lang/links/blob/master/INSTALL.md ; https://github.com/links-lang/links-tutorial

In the https://github.com/links-lang/links-tutorial it is offered to install the Links to VirtualBox 
(with Vagrant to automate the process).

Here we try to make Docker environment. It is good to visit the above mentioned referencies and the language manual : https://links-lang.org/quick-help.html

Comments in Dockerfile may also help. 

We start FROM  opam/ocaml2 https://hub.docker.com/r/ocaml/opam2/ and use the refs to add needes packages for
postgreesql and links installation within container. 

Using postgres credential we make new links databae and move all the credentials to opam user. 

THE PASSWORD IS HARD CODED IN THE CONTAINER. IT WILL BE BETTER IF YOU REBUILD THE IMAGE FROM 
Dockerfile CHANGING TO YOUR PASSWORD IN THE CODE OF Dockerfile (IN 2 PLACES). THE PASSWORD IN SAVED IN config FILE IN links_folder.

The environment is for the learning, not for a production. 

Within container you may print '$linx' to go to the interctive environment. 
With '$linx --config=config' you may test the data base created. See the session below. 

# interactive output
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
With
 
$./web_examples 

script the web examples (without database) will be awailable on your specified localhost port 
(we expect you do something like   $docker run -it -p 8080:8080 image_name) 

The full set of examples is awaiable at Links language official web page : https://links-lang.org/
(Demo programms).

Below is the script. 
##########
```
#!/bin/bash

linx --path=$OPAM_SWITCH_PREFIX/share/links/examples \
     --path=$OPAM_SWITCH_PREFIX/share/links/examples/games \
            $OPAM_SWITCH_PREFIX/share/links/examples/webserver/examples-nodb.links

```
###############

As an example of using the environment,  from the current folder we did : 
$mkdir links_examples
$touch todo.links

We can make the todo.links file with the content (the well known todo web application), 
there is front end and back end parts in the file, both will be started by execution the 
main() function. The example is from the Links tutorial : https://github.com/links-lang/links-tutorial/blob/master/4_todo/todo.links 

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
Run the container with the mount : 
```
dmitri@dmitri-Aspire-A314-32:~/docker_linx$ sudo docker run -v $(pwd)/links_examples:/links_examples  -it -p 8080:8080 links_2
 * Restarting PostgreSQL 10 database server                                                             [ OK ]
```

And from within running container : 
```
opam@98da55efced9:~/opam-repository/links_folder$ linx /links_examples/todo.links

```

The todo app will start at localhost:8080



