Description
-----------
A PageRank simulation (simplified), using [CoffeeScript](http://coffeescript.org/).

![screenshot](https://drive.google.com/uc?export=view&id=0B31-CIvNW1LdWm5NWXlqU25Hc2s)

TODO
----
* use SUPPR button to remove a node or a link

Links
-----
* for the PageRank algorithm, I followed the article [here](http://wassner.blogspot.fr/2014/06/pourquoi-est-ce-important-la-plupart.html) (in French).
* another article: [here](http://williamcotton.com/pagerank-explained-with-javascript).

Nota Bene
---------
The `---` lines at the beginning of each CoffeeScript file are not CoffeeScript code, it's a code to indicate to the server ([Jekyll](http://jekyllrb.com/)) that the file must be served. To launch Jekyll, install it and type `jekyll serve --watch`.

If you don't want to use Jekyll to display the web page, you can simply launch the index.html file with your browser, but you need to remove the `---` at the beginning of each CoffeeScript file, and then compile them with `coffee --compile *.coffee` to generate the javascript files.
