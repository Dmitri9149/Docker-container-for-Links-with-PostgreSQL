


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



##########
```
#!/bin/bash

linx --path=$OPAM_SWITCH_PREFIX/share/links/examples \
     --path=$OPAM_SWITCH_PREFIX/share/links/examples/games \
            $OPAM_SWITCH_PREFIX/share/links/examples/webserver/examples-nodb.links

```
###############
