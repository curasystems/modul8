## require()

Modul8's `require()` works hand in hand with a private `define()` call that gets pre-pended to the compiled source.
On compilation each module is wrapped in a define call (encapsulating variables not explicitly exported) that also give each of these modules
the necessary context for the `require()` calls the module may make. All context is stored via closures and will be hidden from you.

### Ways to require

There are four different ways to use require:

 - **Globally**:        `require('subfolder/module.js')`. This will scan all the domains (except data) for a matching structure, starting the search at your current location.
 A gloabl require does not care about your current location.

 - **Relatively**:      `require('./module.js')`. This will scan only the current domain and the current folder
 You can keep chaining on '../' to go up directories, but this has to happen in the beginning of the require string:
 `require('./../subfolder/../basemodule.js')` **is not legal** while `require('./../basemodule.js')` **is**.

 - **Domain Specific**  `require('shared::val.js')`. Scans the specified domain (only) as if it were a global require from within that domain.
 You cannot do relative requires combined with domain prefixes as this is either non-sensical (cross domain case: folder structure between domains lost on the browser),
 or unnecessary (same origin case: you should simply be using relative requires).

 - **Data Domain**:     `require('data::datakey')`. The data domain is special. It is there to allow requiring of data that was `add()`-chained on the `data()` method.
 It does not arise from physical files, and will not show up in the dependency tree. It is simply data you have attached deliberately.

#### File extensions

 File extensions are never necessary, but you can (and sometimes should) include them for specificity (except for on the data domain).

 To see why you perhaps should, consider the simplified algorithm `require()` uses to resolve the files you required on the server:

    name = require input, domain = current domait (stored in closure)
    while(domain)
      return true if exists(domain + name)
      return true if exists(domain + name + '.js')
      return true if exists(domain + name + '.coffee')
      domain = nextDomain
    return false


 If there is one thing to learn from it is is that you absolutely **DO NOT omit extensions and keep .js and .coffee versions in the same folder**
 or you will quickly become very frustrated as to why your coffee changes arent doing anything.


### Hooking into define

 It is plausible that you may at some point (using an asynchronous script loader) want to register the loaded modules with the existing require system.
 This is at the moment possible only through referencing the private `M8.define()`. Since this is still private, we will not document it yet.
 It is likely that we will want to expose `define()` for public hookins such as this, but it is also arguable that the script loader should get the
 exports object directly. In such a scenario it may make more sense to expose an API on the client for adding modules to the _data_ domain.
